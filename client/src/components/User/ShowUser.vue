<template>
  <div class="component-wrapper container">
    <main-header navsel="back"></main-header>
    <h1>แสดงข้อมูลผู้ใช้งาน</h1>
    <div class="form-wrapper" v-if="user != null">
      <div class="form-horizontal">
        <div class="form-group">
          <label for class="control-label col-md-2">Name:</label>
          <div class="col-md-8">
            <input class="form-control" type="text" v-model="user.name" disabled>
          </div>
        </div>

        <div class="form-group">
          <label for class="control-label col-md-2">Lastname:</label>
          <div class="col-md-8">
            <input class="form-control" type="text" v-model="user.name" disabled>
          </div>
        </div>
        <div class="form-group">
          <label for class="control-label col-md-2">Email:</label>
          <div class="col-md-8">
            <input class="form-control" type="email" v-model="user.email" disabled>
          </div>
        </div>
      </div>
    </div>
    <div class="back-nav">
      <button class="btn btn-success" v-on:click="navigateTo('/users')">
        <i class="fas fa-arrow-left"></i> Back..
      </button>
    </div>
    <br>
  </div>
</template>
<script>
import UsersService from "@/services/UsersService";
export default {
  data() {
    return {
      user: null
    };
  },
  async created() {
    try {
      let userId = this.$route.params.userId;
      this.user = (await UsersService.show(userId)).data;
      this.user.password = "";
    } catch (error) {
      console.log(error);
    }
  },
  methods: {
    navigateTo(route) {
      this.$router.push(route);
    }
  }
};
</script>
<style scoped>
.component-wrapper {
  margin-top: 80px;
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
}
.component-wrapper h1 {
  text-align: center;
}
.form-wrapper {
  margin-top: 30px;
}
.back-nav {
  margin-top: 20px;
  text-align: center;
}
</style>