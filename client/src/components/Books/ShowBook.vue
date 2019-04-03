<template>
  <div class="container component-wrapper">
    <main-header navsel="back"></main-header>
    <div class="book-wrapper" v-if="book != null">
      <h1>{{ book.title }}</h1>
      <p>
        <strong>Category:</strong>
        : {{ book.category }}
      </p>
      <p>
        <strong>Status:</strong>
        {{ book.status }}
      </p>
      <div class="content" v-html="book.content"></div>
      <!-- <p>category: {{ book.category }}</p>
      <p>status: {{ book.status }}</p>-->
    </div>
    <div class="back-nav">
      <button class="btn btn-success" v-on:click="navigateTo('/books')">
        <i class="fas fa-arrow-left"></i> Back..
      </button>
    </div>
    <br>
  </div>
</template>
<script>
import BooksService from "@/services/BooksService";
export default {
  data() {
    return {
      book: null
    };
  },
  async created() {
    try {
      let bookId = this.$route.params.bookId;
      this.book = (await BooksService.show(bookId)).data;
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
}
.book-wrapper {
  margin-top: 20px;
  margin-left: auto;
  margin-right: auto;
  padding: 40px;
  box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.2);
}
.back-nav {
  margin-top: 20px;
  text-align: center;
}
.book-wrapper h1 {
  text-align: center;
  font-family: "kanit";
  padding-bottom: 50px;
}
.book-wrapper p {
  font-family: "kanit";
  font-size: 1.4em;
}
.book-wrapper .content {
  font-family: "kanit";
  font-size: 1.2em;
}
</style>