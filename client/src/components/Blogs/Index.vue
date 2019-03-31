<template>
  <div>
    <div class="blog-header">
      <h2>ส่วนจัดการบล็อก</h2>
      <div>
        <form>
          <input type="text" v-model="search" placeholder="Search">
        </form>
      </div>
      <br>
      <div>
        <button v-on:click="navigateTo('/blog/create')">create blog</button>
        <strong>จำนวน blog:</strong>
        {{results.length}}
      </div>
      <ul class="categories">
        <li v-for="cate in category" v-bind:key="cate.index">
          <a v-on:click.prevent="setCategory(cate)" href="#">{{ cate }}</a>
        </li>
        <li class="clear">
          <a v-on:click.prevent="setCategory(' ')" href="#">Clear</a>
        </li>
      </ul>
      <div class="clearfix"></div>
    </div>
    <div v-if="blogs.length === 0" class="empty-blog">*** ไม่มีข้อมูล ***</div>
    <transition-group name="fade">
      <div v-for="blog in blogs" v-bind:key="blog.id" class="blog-list">
        <!-- <p>id: {{ blog.id }}</p> -->
        <div class="blog-pic">
          <transition name="fade">
            <div class="thumbnail-pic" v-if="blog.thumbnail != 'null'">
              <img :src="BASE_URL+blog.thumbnail" alt="thumbnail">
            </div>
          </transition>
        </div>
        <h3>{{ blog.title }}</h3>
        <div v-html="blog.content.slice(0,200) + '...'"></div>
        <div class="blog-info">
          <p>
            <strong>Category:</strong>
            {{ blog.category }}
          </p>
          <p>
            <strong>Create:</strong>
            {{ blog.createdAt }}
          </p>
          <!-- <p>status: {{ blog.status }}</p> -->
          <p>
            <button v-on:click="navigateTo('/blog/'+ blog.id)">ดู blog</button>
            <button v-on:click="navigateTo('/blog/edit/'+ blog.id)">แก้ไข blog</button>
            <button v-on:click="deleteBlog(blog)">ลบข้อมูล</button>
          </p>
        </div>
        <div class="clearfix"></div>
      </div>
    </transition-group>
    <div id="blog-list-bottom">
      <div
        class="blog-load-finished"
        v-if="blogs.length === results.length && results.length > 0 && loading === false"
      >โหลดข้อมูลครบแล้ว</div>
    </div>
  </div>
</template>

<script>
import BlogsService from "@/services/BlogsService";
import _ from "lodash";
import ScrollMonitor from "scrollMonitor";

let LOAD_NUM = 3;
let pageWatcher;

export default {
  data() {
    return {
      blogs: [],
      BASE_URL: "http://localhost:8081/assets/uploads/",
      search: "",
      results: [],
      category: [],
      loading: false
    };
  },
  // async created() {
  //   this.blogs = (await BlogsService.index()).data;
  // },
  methods: {
    navigateTo(route) {
      this.$router.push(route);
    },
    async deleteBlog(blog) {
      let result = confirm("Want to delete?");
      if (result) {
        try {
          await BlogsService.delete(blog);
          this.refreshData();
        } catch (err) {
          console.log(err);
        }
      }
    },
    async refreshData() {
      this.blogs = (await BlogsService.index()).data;
    },
    appendResults: function() {
      if (this.blogs.length < this.results.length) {
        let toAppend = this.results.slice(
          this.blogs.length,
          LOAD_NUM + this.blogs.length
        );
        this.blogs = this.blogs.concat(toAppend);
      }
    },
    setCategory(keyword) {
      if (keyword === " ") {
        this.search = "";
        console.log("null");
      } else {
        this.search = keyword;
      }
    }
  },
  watch: {
    search: _.debounce(async function(value) {
      const route = {
        name: "blogs"
      };

      if (this.search !== "") {
        route.query = {
          search: this.search
        };
      }

      console.log("search: " + this.search);
      this.$router.push(route);
    }, 700),

    "$route.query.search": {
      immediate: true,
      async handler(value) {
        // this.blogs = (await BlogsService.index(value)).data;
        this.blogs = [];
        this.results = [];
        this.loading = true;
        this.results = (await BlogsService.index(value)).data;
        this.appendResults();

        console.log("search >>" + value);
        this.results.forEach(blog => {
          if (this.category.length > 0) {
            // console.log(this.category.indexOf(blog.category))
            if (this.category.indexOf(blog.category) === -1) {
              this.category.push(blog.category);
            }
          } else {
            this.category.push(blog.category);
          }
        });
        this.loading = false;
        this.search = value;
        // console.log(this.category)
      }
    }
  },
  updated() {
    let sens = document.querySelector("#blog-list-bottom");
    pageWatcher = ScrollMonitor.create(sens);
    pageWatcher.enterViewport(this.appendResults);
  },
  beforeUpdated() {
    if (pageWatcher) {
      pageWatcher.destroy();
      pageWatcher = null;
    }
  }
};
</script>

<style scoped>
.empty-blog {
  width: 100%;
  text-align: center;
  padding: 10px;
  background: darksalmon;
  color: white;
}
/* thumbnail */
.thumbnail-pic img {
  width: 200px;
  padding: 5px 10px 0px 0px;
}
.blog-info {
  float: left;
}
.blog-pic {
  float: left;
}
.clearfix {
  clear: both;
}
.blog-list {
  border: solid 1px #dfdfdf;
  margin-bottom: 10px;
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
  padding: 5px;
  box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.1);
}
.blog-header {
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
}
#blog-list-bottom {
  padding: 4px;
  text-align: center;
  background: seagreen;
  color: white;
}
.categories {
  padding: 0;
  list-style: none;
  float: left;
}
.categories li {
  float: left;
  padding: 2px;
}
.categories li a {
  padding: 5px 10px 5px 10px;
  background: paleturquoise;
  color: black;
  text-decoration: none;
}
.categories li.clear a {
  background: tomato;
  color: white;
}
#blog-list-bottom {
  padding-top: 4px;
}
.blog-load-finished {
  padding: 4px;
  text-align: center;
  background: seagreen;
  color: white;
}
</style>