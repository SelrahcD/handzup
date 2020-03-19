<template>
<div>
    <button v-on:click="raiseHand">Raise hand</button>
</div>
</template>

<script>
    import socket from "../socket"
    let channel = null;
    export default {
        data: () => {
            return {
            }
        },
        mounted() {
            channel = socket.channel("room:" + this.$route.params.id, {name: "Charles"})
            channel.join()
                .receive("ok", resp => { console.log("Joined successfully", resp) })
                .receive("error", resp => { console.log("Unable to join", resp) })

            channel.on("hand_raised", payload => {
                console.log(payload)
            })
        },
        methods: {
            raiseHand: () => {
                channel.push("raise_hand")
            }
        }
    }
</script>