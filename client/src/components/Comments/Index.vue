<template>
  <div>
    <main-header navsel="back"></main-header>
    <div class="comment-header container">
      <div>
        <form class="form-inline form-search">
          <div class="form-group">
            <div class="input-group">
              <input
                type="text"
                v-model="search"
                class="form-control"
                id="exampleInputAmount"
                placeholder="Search"
              >
              <div class="input-group-addon">
                <i class="fas fa-search"></i>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="create-comment">
        <strong>จำนวน:</strong>
        {{results.length}} comments
      </div>
    </div>
    <div class="container">
      <div v-for="comment in comments" v-bind:key="comment.id" class="comment-list">
        <p>
          <strong>Comment:</strong>
        </p>
        <p>{{ comment.comment }}</p>
        <!-- <p>password: {{ comment.password }}</p> -->
        <p>สร้างเมื่อ: {{ comment.createdAt }}</p>
        <p>
          <button
            class="btn btn-sm btn-info"
            v-on:click="navigateTo('/comment/'+ comment.id)"
          >ดูบล็อกที่ Comment</button>
          <button class="btn btn-sm btn-danger" v-on:click="deleteComment(comment)">ลบข้อมูล</button>
        </p>
      </div>
    </div>
    <div v-if="comments.length === 0 && loading === false" class="empty-comment">*** ไม่มีข้อมูล ***</div>
    <div id="comment-list-bottom">
      <div
        class="comment-load-finished"
        v-if="comments.length === results.length && results.length > 0"
      >โหลดข้อมูลครบแล้ว</div>
    </div>
  </div>
</template>
<script>
import CommentsService from "@/services/CommentsService";
import _ from "lodash";
import ScrollMonitor from "scrollMonitor";
let LOAD_NUM = 2;
let pageWatcher;
export default {
  data() {
    return {
      comments: [],
      // BASE_URL: "http://localhost:8081/assets/uploads/",
      search: "",
      results: [],
      category: [],
      loading: false
    };
  },
  watch: {
    search: _.debounce(async function(value) {
      const route = {
        name: "comments"
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
        this.comments = [];
        this.results = [];
        this.loading = true;
        this.results = (await CommentsService.index(value)).data;
        // this.appendResults()

        this.search = value;
      }
    }
  },
  // async created () {
  //   this.comments = (await CommentsService.index()).data
  // },
  methods: {
    appendResults: function() {
      if (this.comments.length < this.results.length) {
        let toAppend = this.results.slice(
          this.comments.length,
          LOAD_NUM + this.comments.length
        );
        this.comments = this.comments.concat(toAppend);
      }
    },
    navigateTo(route) {
      this.$router.push(route);
    },
    async deleteComment(comment) {
      try {
        await CommentsService.delete(comment);
        this.refreshData();
      } catch (err) {
        console.log(err);
      }
    },
    async refreshData() {
      this.comments = (await CommentsService.index()).data;
    },
    async deleteComment(comment) {
      var result = confirm("Want to delete?");
      if (result) {
        try {
          await CommentsService.delete(comment);
          this.refreshData();
        } catch (err) {
          console.log(err);
        }
      }
    }
  },
  updated() {
    let sens = document.querySelector("#comment-list-bottom");
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
.comment-header {
  margin-top: 80px;
}
.comment-list {
  border: solid 1px #dfdfdf;
  margin-bottom: 10px;
  padding: 5px;
  box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.1);
}
#comment-list-bottom {
  padding-top: 4px;
}
.comment-load-finished {
  padding: 4px;
  text-align: center;
  background: seagreen;
  color: white;
}
.create-comment {
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>