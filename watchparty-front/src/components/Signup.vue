<template>
  <div>
    <div>
      <h3>Cadastre-se</h3>
      <form @submit.prevent="signup">
        <div v-if="error">{{ error }}</div>
        <div>
          <label for="email" class="label">E-mail</label>
          <input type="email" v-model="email" class="input" id="email" placeholder="seuemail@gmail.com">
        </div>
        <div>
          <label for="password" class="label">Senha</label>
          <input type="password" v-model="password" class="input" id="password" placeholder="senha">
        </div>
        <div>
          <label for="password_confirmation" class="label">Confirme sua senha</label>
          <input type="password" v-model="password_confirmation" class="input" id="password_confirmation"
            placeholder="confirme sua senha">
        </div>
        <button type="submit">Cadastrar</button>
        <div><router-link to="/">Login</router-link></div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$httpPlain.post('/signup', { email: this.email, password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }

      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/rooms')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/rooms')
      }
    }
  }
}
</script>
