<template>
  <div class="container book-wrapper">
    <main-header navsel="back"></main-header>
    <h1>Edit Book</h1>
    <form v-on:submit.prevent="editBook">
      <!-- <p>title: <input type="text" v-model="book.title"></p> -->
      <p>
        <label for class="control-label">Title:</label>
        <input type="text" v-model="book.title" class="form-control">
      </p>
      <transition name="fade">
        <div class="thumbnail-pic" v-if="book.thumbnail != 'null'">
          <img class="img-thumbnail" :src="BASE_URL+book.thumbnail" alt="thumbnail">
        </div>
      </transition>
      <form id="upload-form" enctype="multipart/form-data" novalidate>
        <div class="dropbox">
          <input
            type="file"
            multiple
            :name="uploadFieldName"
            :disabled="isSaving"
            @change="filesChange($event.target.name,
$event.target.files); fileCount = $event.target.files.length"
            accept="image/*"
            class="input-file"
          >
          <!-- <p v-if="isInitial || isSuccess"> -->
          <p v-if="isInitial">
            Drag your file(s) here to begin
            <br>or click to browse
          </p>
          <p v-if="isSaving">Uploading {{ fileCount }} files...</p>
          <p v-if="isSuccess">Upload Successful.</p>
        </div>
      </form>
      <div>
        <transition-group tag="ul" name="fade" class="pictures">
          <li v-for="picture in pictures" v-bind:key="picture.id">
            <img
              class="img-thumbnail"
              style="margin-bottom:5px;"
              :src="BASE_URL+picture.name"
              alt="picture image"
            >
            <br>
            <button
              class="btn btn-xs btn-info"
              v-on:click.prevent="useThumbnail(picture.name)"
            >Thumbnail</button>
            <button class="btn btn-xs btn-danger" v-on:click.prevent="delFile(picture)">Delete</button>
          </li>
        </transition-group>
        <div class="clearfix"></div>
      </div>
      <p>
        <strong>content:</strong>
      </p>
      <p>
        <vue-ckeditor
          v-model.lazy="book.content"
          :config="config"
          @blur="onBlur($event)"
          @focus="onFocus($event)"
        />
      </p>
      <p>
        <label class="control-label">Category :</label>
        <input type="text" v-model="book.category" class="form-control">
      </p>
      <p>
        <label class="control-label">Prices :</label>
        <input type="text" v-model="book.prices" class="form-control">
      </p>
      <p>
        <button class="btn btn-warning" type="submit">Update Book</button>
        <button class="btn btn-default" type="button" v-on:click="navigateTo('/books')">Back</button>
      </p>
    </form>
  </div>
</template>
<script>
import BooksService from "@/services/BooksService";
import VueCkeditor from "vue-ckeditor2";
import UploadService from "@/services/UploadService";
import config from "@/config/config";

const STATUS_INITIAL = 0,
  STATUS_SAVING = 1,
  STATUS_SUCCESS = 2,
  STATUS_FAILED = 3;

export default {
  data() {
    return {
      book: {
        title: "",
        thumbnail: "null",
        pictures: "null",
        content: "",
        category: "",
        status: "",
        prices: ""
      },
      config: {
        // toolbar: [
        //   ["Bold", "Italic", "Underline", "Strike", "Subscript", "Superscript"]
        // ],
        height: 300
      },
      // upload data
      BASE_URL: config.URL_UPLOAD,
      error: null,
      uploadError: null,
      currentStatus: null,
      uploadFieldName: "userPhoto",
      uploadedFileNames: [],
      pictures: [],
      pictureIndex: 0
    };
  },
  methods: {
    navigateTo(route) {
      this.$router.push(route);
    },
    async editBook() {
      this.book.pictures = JSON.stringify(this.pictures);
      try {
        await BooksService.put(this.book);
        this.$router.push({
          name: "books"
        });
      } catch (err) {
        console.log(err);
      }
    },
    onBlur(editor) {
      console.log(editor);
    },
    onFocus(editor) {
      console.log(editor);
    },
    // upload
    wait(ms) {
      return x => {
        return new Promise(resolve => setTimeout(() => resolve(x), ms));
      };
    },
    reset() {
      // reset form to initial state
      this.currentStatus = STATUS_INITIAL;
      // this.uploadedFiles = []
      this.uploadError = null;
      this.uploadedFileNames = [];
    },
    async save(formData) {
      // upload data to the server
      try {
        this.currentStatus = STATUS_SAVING;
        await UploadService.upload(formData);
        this.currentStatus = STATUS_SUCCESS;

        // update image uploaded display
        let pictureJSON = [];
        this.uploadedFileNames.forEach(uploadFilename => {
          let found = false;
          for (let i = 0; i < this.pictures.length; i++) {
            if (this.pictures[i].name == uploadFilename) {
              found = true;
              break;
            }
          }
          if (!found) {
            this.pictureIndex++;
            let pictureJSON = {
              id: this.pictureIndex,
              name: uploadFilename
            };
            this.pictures.push(pictureJSON);
          }
        });
        this.clearUploadResult();
      } catch (error) {
        console.log(error);
        this.currentStatus = STATUS_FAILED;
      }
    },
    filesChange(fieldName, fileList) {
      // handle file changes
      const formData = new FormData();
      if (!fileList.length) return;
      // append the files to FormData
      Array.from(Array(fileList.length).keys()).map(x => {
        formData.append(fieldName, fileList[x], fileList[x].name);
        this.uploadedFileNames.push(fileList[x].name);
      });
      // save it
      this.save(formData);
    },
    clearUploadResult: function() {
      setTimeout(() => this.reset(), 5000);
    },
    async delFile(material) {
      let result = confirm("Want to delete?");
      if (result) {
        let dataJSON = {
          filename: material.name
        };
        await UploadService.delete(dataJSON);
        for (var i = 0; i < this.pictures.length; i++) {
          if (this.pictures[i].id === material.id) {
            this.pictures.splice(i, 1);
            this.materialIndex--;
            break;
          }
        }
      }
    },
    useThumbnail(filename) {
      console.log(filename);
      this.book.thumbnail = filename;
    }
  },
  components: {
    VueCkeditor
  },
  async created() {
    try {
      let bookId = this.$route.params.bookId;
      this.book = (await BooksService.show(bookId)).data;
      this.pictures = JSON.parse(this.book.pictures);
      this.pictureIndex = this.pictures.length;

      this.config.toolbar = [
        {
          name: "document",
          items: [
            "Source",
            "-",
            "Save",
            "NewPage",
            "Preview",
            "Print",
            "-",
            "Templates"
          ]
        },
        {
          name: "clipboard",
          items: [
            "Cut",
            "Copy",
            "Paste",
            "PasteText",
            "PasteFromWord",
            "-",
            "Undo",
            "Redo"
          ]
        },
        {
          name: "editing",
          items: ["Find", "Replace", "-", "SelectAll", "-", "Scayt"]
        },
        {
          name: "forms",
          items: [
            "Form",
            "Checkbox",
            "Radio",
            "TextField",
            "Textarea",
            "Select",
            "Button",
            "ImageButton",
            "HiddenField"
          ]
        },
        "/",
        {
          name: "basicstyles",
          items: [
            "Bold",
            "Italic",
            "Underline",
            "Strike",
            "Subscript",
            "Superscript",
            "-",
            "CopyFormatting",
            "RemoveFormat"
          ]
        },
        {
          name: "paragraph",
          items: [
            "NumberedList",
            "BulletedList",
            "-",
            "Outdent",
            "Indent",
            "-",
            "Blockquote",
            "CreateDiv",
            "-",
            "JustifyLeft",
            "JustifyCenter",
            "JustifyRight",
            "JustifyBlock",
            "-",
            "BidiLtr",
            "BidiRtl",
            "Language"
          ]
        },
        { name: "links", items: ["Link", "Unlink", "Anchor"] },
        {
          name: "insert",
          items: [
            "Image",
            "Flash",
            "Table",
            "HorizontalRule",
            "Smiley",
            "SpecialChar",
            "PageBreak",
            "Iframe",
            "InsertPre"
          ]
        },
        "/",
        { name: "styles", items: ["Styles", "Format", "Font", "FontSize"] },
        { name: "colors", items: ["TextColor", "BGColor"] },
        { name: "tools", items: ["Maximize", "ShowBlocks"] },
        { name: "about", items: ["About"] }
      ];
    } catch (error) {
      console.log(error);
    }
  },
  async mounted() {
    try {
      let bookId = this.$route.params.bookId;
      this.book = (await BooksService.show(bookId)).data;
      this.pictures = JSON.parse(this.book.pictures);
    } catch (error) {
      console.log(error);
    }
  },
  computed: {
    isInitial() {
      return this.currentStatus === STATUS_INITIAL;
    },
    isSaving() {
      return this.currentStatus === STATUS_SAVING;
    },
    isSuccess() {
      return this.currentStatus === STATUS_SUCCESS;
    },
    isFailed() {
      return this.currentStatus === STATUS_FAILED;
    }
  }
};
</script>
<style scoped>
.book-wrapper {
  margin-top: 80px;
}
/* thumbnail */
.thumbnail-pic img {
  width: 200px;
  margin-bottom: 10px;
}
/* display uploaded pic */
ul.pictures {
  list-style: none;
  padding: 0;
  margin: 0;
  float: left;
  padding-top: 10px;
  padding-bottom: 10px;
}
ul.pictures li {
  float: left;
}
ul.pictures li img {
  max-width: 180px;
  margin-right: 20px;
}
.clearfix {
  clear: both;
}
/* uplaod */
.dropbox {
  outline: 2px dashed grey; /* the dash box */
  text-align: center;
  padding: 50px 0;
}
</style>