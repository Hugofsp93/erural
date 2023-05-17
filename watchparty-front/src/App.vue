<template>
  <div id="app">
    <Header/>
    <div class="general">
      <router-view/>
    </div>
  </div>
</template>

<script>
import Header from '@/components/Header.vue'
import './main.css'

export default {
  name: 'App',
  components: {
    Header
  }
}
</script>

<style>
#app {
  background-color: #ccd1cb;
  height: 100vh;
}

.general {
  padding: 1rem 2rem;
}
</style>
