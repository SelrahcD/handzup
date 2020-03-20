<template>
<div class="md:flex md:flex-row mb-4 px-4">
    <div class="md:mr-4 md:w-3/4">
        <div class="bg-white rounded p-5 shadow">
            <h2 class="text-xl mb-2">Discussion</h2>
            <div>
                <ul>
                    <li v-for="name in waitingList">
                        {{ name }}
                    </li>
                </ul>
            </div>
            <div class="text-center">
                <button v-on:click="raiseHand" v-show="!isWaiting"
                        class="h-24 w-24 bg-blue-500 hover:bg-blue-700 border-b-4 border-blue-700 hover:border-blue-500 text-white font-bold py-2 px-4 rounded-full">
                    <div>
                        <svg class="w-6 h-6 fill-current inline" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M17 16a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4.01V4a1 1 0 0 1 1-1 1 1 0 0 1 1 1v6h1V2a1 1 0 0 1 1-1 1 1 0 0 1 1 1v8h1V1a1 1 0 1 1 2 0v9h1V2a1 1 0 0 1 1-1 1 1 0 0 1 1 1v13h1V9a1 1 0 0 1 1-1h1v8z"/></svg>
                    </div>
                    <span class="text-xs">Raise hand</span>
                </button>
                <button v-on:click="raiseHand" v-show="isWaiting"
                        class="h-24 w-24 bg-orange-500 hover:bg-orange-700 border-b-4 border-orange-700 hover:border-orange-500 text-white font-bold py-2 px-4 rounded-full">
                    <div>
                        <svg class="w-6 h-6 fill-current inline" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M17 16a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4.01V4a1 1 0 0 1 1-1 1 1 0 0 1 1 1v6h1V2a1 1 0 0 1 1-1 1 1 0 0 1 1 1v8h1V1a1 1 0 1 1 2 0v9h1V2a1 1 0 0 1 1-1 1 1 0 0 1 1 1v13h1V9a1 1 0 0 1 1-1h1v8z"/></svg>
                    </div>
                    <span class="text-xs">Oups...</span>
                </button>
            </div>

        </div>
    </div>

    <div class="mt-4 md:mt-0 md:w-1/4">
        <div class="bg-white rounded p-5 shadow">
            <h2 class="text-xl mb-2">List of connected users</h2>
            <ul>
                <li v-for="name in connectedUsers">
                    {{name}}
                </li>
            </ul>
        </div>
    </div>

</div>
</template>

<script>
    import socket from "../socket"
    import {Presence} from "phoenix"

    let name = "Charles_" + Math.floor(Math.random() * 10);

    export default {
        data() {
            return {
                connectedUsers: [],
                waitingList: [],
                channel: null
            }
        },
        computed: {
            isWaiting() {
                return this.waitingList.indexOf(name) > -1
            }
        },
        watch: {
            $route(to, from) {
                this.joinChannel(this.$route.params.id)
            }
        },
        mounted() {
            this.joinChannel(this.$route.params.id)
        },
        methods: {
            raiseHand() {
                this.channel.push("raise_hand")
            },
            joinChannel(channelName) {
                if(this.channel) {
                    this.channel.leave()
                }

                this.channel = socket.channel("room:" + this.$route.params.id, {name: name})

                let presence = new Presence(this.channel)

                presence.onSync(() => {
                    this.connectedUsers = []

                    presence.list((id, {metas: [user, ...rest]}) => {
                        this.connectedUsers.push(user.name)
                    })
                })

                this.channel.on("waiting_list_updated", payload => {
                    this.waitingList = payload.list
                })

                this.channel.join()
                    .receive("ok", resp => { console.log("Joined successfully", resp) })
                    .receive("error", resp => { console.log("Unable to join", resp) })
            }

        }
    }
</script>