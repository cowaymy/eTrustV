<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<!-- 
####################################
AUIGrid Hompage     : http://www.auisoft.net/price.html
Grid Documentation  : http://www.auisoft.net/documentation/auigrid/index.html
####################################
 -->    
    <script type="text/javaScript" language="javascript">
    
    var myGridID;

 // document ready 
 $(document).ready(function() { 
     
     // 최초 그리드 생성함.
     createInitGrid();
     
     // IE10, 11은 readAsBinaryString 지원을 안함. 따라서 체크함.
     var rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";

     // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
     function checkHTML5Brower() {
         var isCompatible = false;
         if (window.File && window.FileReader && window.FileList && window.Blob) {
             isCompatible = true;
         }
         return isCompatible;
     };
     
     // 파일 선택하기
     $('#fileSelector').on('change', function(evt) {
         if (!checkHTML5Brower()) {
             alert("브라우저가 HTML5 를 지원하지 않습니다.\r\n서버로 업로드해서 해결하십시오.");
             return;
         } else {
             var data = null;
             var file = evt.target.files[0];
             if (typeof file == "undefined") {
                 alert("파일 선택 시 오류 발생!!");
                 return;
             }
             var reader = new FileReader();

             reader.onload = function(e) {
                 var data = e.target.result;

                 /* 엑셀 바이너리 읽기 */
                 var workbook;

                 if(rABS) { // 일반적인 바이너리 지원하는 경우
                     workbook = XLSX.read(data, {type: 'binary'});
                 } else { // IE 10, 11인 경우
                     var arr = fixdata(data);
                     workbook = XLSX.read(btoa(arr), {type: 'base64'});
                 }

                 var jsonObj = process_wb(workbook);

                 console.log(JSON.stringify(jsonObj));
                 
                 createAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
             };

             if(rABS) reader.readAsBinaryString(file);
             else reader.readAsArrayBuffer(file);
             
         }
     });

 });

 // IE10, 11는 바이너리스트링 못읽기 때문에 ArrayBuffer 처리 하기 위함.
 function fixdata(data) {
     var o = "", l = 0, w = 10240;
     for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
     o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
     return o;
 };

 // 파싱된 시트의 CDATA 제거 후 반환.
 function process_wb(wb) {
     var output = "";
     output = JSON.stringify(to_json(wb));

     output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
     return JSON.parse(output);
 };

 // 엑셀 시트를 파싱하여 반환
 function to_json(workbook) {
     var result = {};
     workbook.SheetNames.forEach(function(sheetName) {
         var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName], {defval:""});

         console.log(roa);
         alert(11);

         if(roa.length > 0){
             result[sheetName] = roa;
         }
     });
     return result;
 }

 // 엑셀 파일 시트에서 파싱한 JSON 데이터 기반으로 그리드 동적 생성
 function createAUIGrid(jsonData) {
     if(AUIGrid.isCreated(myGridID)) {
         AUIGrid.destroy(myGridID);
         myGridID = null;
     }
     
     var columnLayout = [];

     // 현재 엑셀 파일의 0번째 행을 기준으로 컬럼을 작성함.
     // 만약 상단에 문서 제목과 같이 있는 경우
     // 조정 필요.
     var firstRow = jsonData[0];

     if(typeof firstRow == "undefined") {
         alert("AUIGrid 로 변환할 수 없는 엑셀 파일입니다.");
         return;
     }

     $.each(firstRow, function(n,v) {
         columnLayout.push({
             dataField : n,
             headerText : n,
             width : 100
         });
     });
     
     // 그리드 생성
     myGridID = AUIGrid.create("#grid_wrap", columnLayout);
     
     // 그리드에 데이터 삽입
     AUIGrid.setGridData(myGridID, jsonData);

 };


 //최초 그리드 생성..
 function createInitGrid() {
     
     var columnLayout = [];
     
     for(var i=0; i<10; i++) {
         columnLayout.push({
             dataField : "f" + i,
             headerText : String.fromCharCode(65 + i),
             width : 80
         });
     }
     
     // 그리드 속성 설정
     var gridPros = {
         noDataMessage : "로컬 PC의 엑셀 파일을 선택하십시오."
     };

     // 실제로 #grid_wrap 에 그리드 생성
     myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
     
     // 그리드 최초에 빈 데이터 넣음.
     AUIGrid.setGridData(myGridID, []);
 }
 
// 아이템들 확인하기
 function checkItems() {

     var itemsObject = AUIGrid.exportToObject("#grid_wrap");
     //alert(itemsObject);
     alert(JSON.stringify(itemsObject));
 }
 
//서버로 전송.
 function fn_saveSampleGridData(){
     Common.ajax("POST", "/sample/saveSampleGridData.do", AUIGrid.exportToObject("#grid_wrap"), function(result) {
         alert("성공");
         console.log("성공.");
         console.log("data : " + result);
     },  function(jqXHR, textStatus, errorThrown) {
         try {
             console.log("status : " + jqXHR.status);
             console.log("code : " + jqXHR.responseJSON.code);
             console.log("message : " + jqXHR.responseJSON.message);
             console.log("detailMessage : "
                     + jqXHR.responseJSON.detailMessage);
         } catch (e) {
             console.log(e);
         }

         alert("Fail : " + jqXHR.responseJSON.message);
     });
 }

    </script>

<div class="wrap">        
        <div id="content_pop">
            <!-- 타이틀 -->
            <div id="title">
                <ul>
                    <li><img src="<c:url value='/resources/images/egovframework/example/title_dot.gif'/>" alt=""/><spring:message code="list.sample" /></li>
                </ul>
            </div>
            
            <form id="searchForm" method="get" action="">
                 id : <input type="text" id="sId" name="sId"/><br/>
                 name : <input type="text" id="sName" name="sName"/><br/>
                 
                 <input type="button" class="btn" onclick="javascript:fn_getSampleListAjax();" value="조회"/>
             </form>
            
            
            <div id="main">
			    <div class="desc">
			        <p>AUIGrid 자체적으로 엑셀 임포팅 기능은 지원하지 않습니다.</p>
			        <p>다만, XLSX 파일(또는 XLS)를 JSON 으로 파싱해 주는 라이브러(SheetJS js-xlsx)를 활용하여 동적으로 AUIGrid 임포팅을 구현한 응용 데모입니다.</p>
			        <p> SheetJS 의 js-xlsx 라이브러리 활용, 출처 : <a href="https://github.com/SheetJS/js-xlsx" target="_blank">https://github.com/SheetJS/js-xlsx</a> </p>
			        <p>SheetJS 의 js-xlsx 라이브러리는 아파치 라이센스 2.0 (Apache License v2.0, http://www.apache.org/licenses/LICENSE-2.0) 으로 상업적 용도로 사용해도 무방하며 아파치 라이센스 2.0 을 명시해야 합니다.</p>
			        <p>본 데모는 기본적인 구현 데모로, 엑셀 파일의 상단에 제목이나 기타 텍스트가 존재한다면 설정을 다르게 할 필요가 있습니다.</p>
			        <p>아래 샘플 파일 다운 받아 적용해 보세요.</p>
			        <p>테스트 파일 다운 받기 : <a href="./data/import_test.xlsx" target="_blank">import_test.xlsx</a>, 2번 테스트 파일 : <a href="./data/import_test2.xlsx" target="_blank">import_test2.xlsx</a></p>
			        
			        <!-- 파일 읽기  -->
			        <input type="file" id="fileSelector" name="files" accept=".xlsx">
			    </div>

                <div>
                    <!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
                    <div id="grid_wrap" style="width:800px; height:300px; margin:0 auto;"></div>
                </div>
                
                <div class="desc_bottom">
                    <p><span onclick="checkItems()" class="btn">아이템 확인하기</span></p><p></p>
                    <p><span onclick="fn_saveSampleGridData()" class="btn">서버로 전송</span></p>
                </div>
            </div>
        </div>
</div>
