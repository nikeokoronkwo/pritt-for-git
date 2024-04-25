<script setup>
import { ref } from "vue"
function handleFolderSelect(event) {
    const selectedFolder = event.target.files[0]; // Assuming only one folder is selected
    this.$refs.folder = selectedFolder;
    // You can now handle the selected folder here, for example, by uploading it to a server
}
async function getDir() {
    const dirHandle = await window.showDirectoryPicker();
    return dirHandle
}

const path = ref("")
</script>

<template>
    <div>
        <h1>Create A New Repository</h1>
        <form>
            <label for="name">Repository Name:</label><br>
            <input type="text" id="name" name="name"><br>
            <label for="path">Repository Path:</label><br>
            <input v-model="path" id="path">
            <br><div>OR</div>
            <button @click="getDir()">Choose Directory</button>
        </form>
    </div>
</template>