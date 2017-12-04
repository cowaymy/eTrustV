<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/master.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/common.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/jquery-ui-custom.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/multiple-select.css" />
    <!-- AUIGrid 테마 CSS 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
    <!-- 원하는 테마가 있다면, 다른 파일로 교체 하십시오. -->
    <link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid_custom_style.css" rel="stylesheet"> <!--  aui grid 관련 재정의 클래스. -->


<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-2.2.4.min.js"></script>
    <!-- <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>  -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.ui.core.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.ui.datepicker.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.mtz.monthpicker.js"></script>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/common.js"></script>        <!-- 일반 공통 js -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/common_pub.js"></script>        <!-- publish js -->
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/util.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.serializejson.js"></script> <!-- Form to jsonObject -->
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/gridCommon.js"></script>    <!-- AUIGrid 공통함수. 같이 추가해 보아요~ -->

<!-- AUIGrid -->        
    <!-- AUIGrid 라이센스 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/AUIGrid/AUIGridLicense.js"></script>
    <!-- 실제적인 AUIGrid 라이브러리입니다. 그리드 출력을 위해 꼭 삽입하십시오.--> 
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/AUIGrid/messages/AUIGrid.messages.en.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/xlsx.full.min.js"></script> <!-- 그리드에 엑셀 데이터 upload 하기 위함. -->
    
    <!-- 그리드 pdf 다운로드용. -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/AUIGrid/AUIGrid.pdfkit.js"></script>
<!-- AUIGrid -->

    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/multiple-select.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/combodraw.js"></script>

    <!-- Display the loading bar when downloading -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.fileDownload.js"></script>
    
    <!-- jQuery Number plugin : https://github.com/customd/jquery-number 참고해보세요  -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.number.min.js"></script>

<!-- TODO : 성능 측정을 위한 스크립트. 측정 후 제거 필요 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.number.min.js"></script>

<script>

    (function(w,d,s,uri,fn){
        w[fn] = w[fn] || function(){ var c = {}; c.uri = arguments[0]; c.trackId = arguments[1]; c.opt = arguments[2]; (w[fn].l=w[fn].l||[]).push(c); }; var o = d.createElement(s); var p = d.getElementsByTagName(s)[0]; o.async = 1; o.src = uri; p.parentNode.insertBefore(o,p);
    })(window,document,'script','http://etrustdev.my.coway.com/resources/appinsightor/appinsightor.min.js','ne');
    ne('http://10.201.32.34:8080/ne.nfl','dev01',{
        xhr: {use: true},
        onerror:true,
        E2E: {
            use: true,
            n$apm: '${n$apm}'
        },
        session:{type:'cookie',value:'JSESSIONID'}
    });​

</script>

<!-- TODO : 성능 측정을 위한 스크립트. 측정 후 제거 필요 -->



    
    