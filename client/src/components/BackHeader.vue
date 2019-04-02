<template>
  <div>
    <!-- new navbar -->
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <a
            class="navbar-brand navbar-link"
            href="#"
            v-on:click.prevent="navigateTo('/dashboard')"
          >
            <img src="../assets/logo.png" id="logo">
          </a>
          <button class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navcol-1">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="iconbar"></span>
            <span class="icon-bar"></span>
          </button>
        </div>
        <div class="collapse navbar-collapse" id="navcol-1">
          <ul class="nav navbar-nav navbar-right">
            <li role="presentation">
              <router-link :to="{name: 'blogs'}">Blogs</router-link>
            </li>
            <li role="presentation">
              <router-link :to="{name: 'users'}">Users</router-link>
            </li>
            <li role="presentation">
              <router-link :to="{name: 'comments'}">Comments</router-link>
            </li>
            <li v-if="!isUserLoggedIn" role="presentation">
              <router-link :to="{name: 'login'}">Login</router-link>
            </li>
            <transition name="fade">
              <li v-if="isUserLoggedIn" role="presentation">
                <a href="#">{{user.name}}</a>
              </li>
            </transition>
            <li v-if="isUserLoggedIn" role="presentation">
              <a href="#" v-on:click.prevent="logout">Logout</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  methods: {
    logout() {
      this.$store.dispatch("setToken", null);
      this.$store.dispatch("setUser", null);
      this.$router.push({
        name: "login"
      });
    }
  },
  computed: {
    ...mapState(["isUserLoggedIn", "user"])
  }
};
</script>
<style scoped>
.navbar-brand > img {
  width: 36px;
  padding: 12px 0;
  margin-top: -20px;
}
a.router-link-active {
  color: yellowgreen !important;
}
</style>