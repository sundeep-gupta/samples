HashMap<String,String> map = ['1':'2']

println map.find {
    it.value.equals('333')
}
