// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"
import VueRouter from "vue-router";
import Vue from "vue";
import Home from './components/Home.vue'

const routes = [
    { path: '/', name: 'home', component: Home },
]

const router = new VueRouter({
    routes // short for `routes: routes`
})

Vue.use(VueRouter)

const app = new Vue({
    router
}).$mount('#app')