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
  height: 200vh;
}

.general {
  padding: 3rem 2rem;
}
</style>
