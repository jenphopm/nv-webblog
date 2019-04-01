<template>
  <div class="user-wrapper container">
    <main-header navsel="back"></main-header>
    <h1>เพิ่มผู้ใช้งาน</h1>
    <div class="form-wrapper">
      <form v-on:submit.prevent="createUser" class="form-horizontal">
        <div class="form-group">
          <label for class="control-label col-md-2">Name:</label>
          <div class="col-md-8">
            <input class="form-control" type="text" v-model="user.name">
          </div>
        </div>

        <div class="form-group">
          <label for class="control-label col-md-2">Lastname:</label>
          <div class="col-md-8">
            <input class="form-control" type="text" v-model="user.lastname">
          </div>
        </div>
        <div class="form-group">
          <label for class="control-label col-md-2">Email:</label>
          <div class="col-md-8">
            <input class="form-control" type="email" v-model="user.email">
          </div>
        </div>
        <div class="form-group">
          <label for class="control-label col-md-2">Password:</label>
          <div class="col-md-8">
            <input class="form-control" type="password" v-model="user.password">
          </div>
        </div>
        <div class="form-group">
          <label class="control-label col-md-2">Type:</label>
          <div class="col-md-8">
            <select class="form-control" v-model="user.type">
              <option value="admin">Admin</option>
              <option value="user">User</option>
            </select>
          </div>
        </div>
        <div class="form-group">
          <div class="col-md-offset-2 col-md-8">
            <button class="btn btn-success" type="submit">
              <i class="fas fa-check"></i> Create User
            </button>
            <button class="btn btn-default" type="button" v-on:click="navigateTo('/users')">Back</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>
<script>
import UsersService from "@/services/UsersService";
export default {
  data() {
    return {
      user: {
        name: "",
        lastname: "",
        email: "",
        password: "",
        status: "active",
        type: "user"
      }
    };
  },
  methods: {
    async createUser() {
      try {
        await UsersService.post(this.user);
        this.$router.push({
          name: "users"
        });
      } catch (err) {
        console.log(err);
      }
    },
    navigateTo(route) {
      this.$router.push(route);
    }
  }
};
</script>
<style scoped>
.user-wrapper {
  margin-top: 80px;
}
.user-wrapper h1 {
  text-align: center;
}
.form-wrapper {
  margin-top: 30px;
}
</style>