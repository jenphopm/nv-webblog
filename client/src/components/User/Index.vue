<template>
  <div>
    <main-header navsel="back"></main-header>
    <div class="user-header container">
      <h2>ส่วน</h2>
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
      <div class="create-user">
        <button class="btn btn-success btn-sm" v-on:click="navigateTo('/user/create')">
          <i class="fas fa-file"></i> Create user
        </button>
        <strong>จำนวน</strong>
        {{results.length}} คน
      </div>
    </div>
    <div class="container">
      <transition-group name="fade">
        <div v-for="user in users" v-bind:key="user.id" class="user-list container">
          <p>id: {{ user.id }}</p>
          <p>ชื่อ-นามสกุล: {{ user.name }} - {{ user.lastname }}</p>
          <p>email: {{ user.email }}</p>
          <!-- <p>password: {{ user.password }}</p> -->
          <p>สร้างเมื่อ: {{ user.createdAt }}</p>
          <p>ระดับการใช้งาน: {{ user.type }}</p>
          <p>
            <button class="btn btn-sm btn-info" v-on:click="navigateTo('/user/'+ user.id)">
              <i class="fab fa-readme"></i> View User
            </button>
            <button class="btn btn-sm btn-warning" v-on:click="navigateTo('/user/edit/'+ user.id)">
              <i class="fas fa-edit"></i> Edit User
            </button>
            <button class="btn btn-sm btn-danger" v-on:click="deleteUser(user)">
              <i class="fas fa-trash-alt"></i> Delete
            </button>
          </p>
          <p>
            <a class="btn btn-danger btn-sm" href="#" v-on:click.prevent="pauseUser(user.id)">
              <i class="fas fa-pause"></i>
              Pause
            </a>&nbsp;
            <a
              class="btn btn-success btn-sm"
              href="#"
              v-on:click.prevent="activeUser(user.id)"
            >
              <i class="fas fa-check"></i>
              Active
            </a>&nbsp;
          </p>
        </div>
      </transition-group>
    </div>
    <div v-if="users.length === 0 && loading === false" class="empty-user">*** ไม่มีข้อมูล ***</div>
    <div id="user-list-bottom">
      <div
        class="user-load-finished"
        v-if="users.length === results.length && results.length > 0"
      >โหลดข้อมูลครบแล้ว</div>
    </div>
  </div>
</template>
<script>
import UsersService from "@/services/UsersService";
import _ from "lodash";
import ScrollMonitor from "scrollMonitor";
let LOAD_NUM = 2;
let pageWatcher;
export default {
  data() {
    return {
      users: [],
      // BASE_URL: "http://localhost:8081/assets/uploads/",
      search: "",
      results: [],
      loading: false
    };
  },
  watch: {
    search: _.debounce(async function(value) {
      const route = {
        name: "users"
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
        this.users = [];
        this.results = [];
        this.loading = true;
        this.results = (await UsersService.index(value)).data;
        this.appendResults();

        this.search = value;
      }
    }
  },
  // async created () {
  //   this.users = (await UsersService.index()).data
  // },
  methods: {
    appendResults: function() {
      if (this.users.length < this.results.length) {
        let toAppend = this.results.slice(
          this.users.length,
          LOAD_NUM + this.users.length
        );
        this.users = this.users.concat(toAppend);
      }
    },
    navigateTo(route) {
      this.$router.push(route);
    },
    async deleteUser(user) {
      let result = confirm("Want to delete?");
      if (result) {
        try {
          await UsersService.delete(user);
          this.refreshData();
        } catch (err) {
          console.log(err);
        }
      }
    },
    async refreshData() {
      this.users = (await UsersService.index()).data;
    },
    async pauseUser(userId) {
      let user = {
        id: userId,
        status: "pause"
      };
      try {
        await UsersService.put(user);
        this.refreshData();
      } catch (error) {
        console.log(error);
      }
    },
    async activeUser(userId) {
      let user = {
        id: userId,
        status: "active"
      };
      try {
        await UsersService.put(user);
        this.refreshData();
      } catch (error) {
        console.log(error);
      }
    }
  },
  updated() {
    let sens = document.querySelector("#user-list-bottom");
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
.user-list {
  border: solid 1px #dfdfdf;
  margin-bottom: 10px;
  margin-left: auto;
  margin-right: auto;
  padding: 5px;
  box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.1);
}
#user-list-bottom {
  padding-top: 4px;
}
.user-load-finished {
  padding: 4px;
  text-align: center;
  background: seagreen;
  color: white;
}
.create-user {
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>