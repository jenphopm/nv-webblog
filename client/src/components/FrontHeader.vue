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
            <img src="@/assets/logo.png" id="logo">
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
              <router-link :to="{name: 'front'}">
                <i class="fas fa-home"></i> Home
              </router-link>
            </li>
            <li role="presentation">
              <router-link :to="{name: 'login'}">Login</router-link>
            </li>
            <li role="presentation">
              <a href="#" v-on:click="logout">Logout</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  methods: {
    logout() {
      this.$store.dispatch("setToken", null);
      this.$store.dispatch("setComment", null);
      this.$router.push({
        name: "login"
      });
    }
  }
};
</script>
<style scoped>
.navbar-brand > img {
  width: 36px;
  padding: 12px 0;
  margin-top: -20px;
}
.navbar-inverse {
  background-color: #51415f;
}
.navbar-inverse .navbar-nav > li > a {
  color: #dbdbf6;
}
</style>