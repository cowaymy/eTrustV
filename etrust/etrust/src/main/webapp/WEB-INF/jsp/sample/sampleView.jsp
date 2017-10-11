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
    
 // AUIGrid 생성 후 반환 ID
    var myGridID;

    // document ready (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){


		// spring message 예시.
    	alert("<spring:message code='sys.msg.success'/>");
        

        // AUIGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);
        
        // cellClick event.
        AUIGrid.bind(myGridID, "cellClick", function( event ) {
            console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            fn_setDetail(myGridID, event.rowIndex);
        });
        
        fn_getSampleListAjax();

    });

    // AUIGrid 칼럼 설정
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [ {
            dataField : "id",
            headerText : "id",
            width : 120
        }, {
            dataField : "name",
            headerText : "Name",
            width : 120
        }, {
            dataField : "description",
            headerText : "description",
            width : 120
        }, {
            dataField : "product",
            headerText : "Product",
            width : 120
        }, {
            dataField : "color",
            headerText : "Color",
            width : 120
        }, {
            dataField : "price",
            headerText : "Price",
            dataType : "numeric",
            style : "my-column",
            width : 120
        }, {
            dataField : "quantity",
            headerText : "Quantity",
            dataType : "numeric",
            width : 120
        }, {
            dataField : "date",
            headerText : "Date",
            width : 120
        }];

    
    // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){      
        //$("#id").val(GridCommon.getCellValue(gridID, rowIdx, "id"));
        //$("#name").val(GridCommon.getCellValue(gridID, rowIdx, "name"));
        //$("#description").val(GridCommon.getCellValue(gridID, rowIdx, "description"));
        
       $("#id").val(AUIGrid.getCellValue(gridID, rowIdx, "id"));                    
       $("#name").val(AUIGrid.getCellValue(gridID, rowIdx, "name"));
       $("#description").val(AUIGrid.getCellValue(gridID, rowIdx, "description")); 
    }  
    
    // 리스트 조회.
    function fn_getSampleListAjax() {
        Common.ajax("GET", "/sample/selectJsonSampleList", $("#searchForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myGridID, result);
        });
    }
    
    // 저장. -- Form 데이터 자동으로 JSON 변경.
    // jquery.serializejson.js 이용. 
    function fn_saveSerializeJSON(){
    	
        // validation check .
        // ..........
        
        
        // 공통 ajax 호출.
        // callback 함수를 바로 구현.
        Common.ajax("POST", "/sample/saveSample", $("#detailForm").serializeJSON(), function(result) {
        //Common.ajax("POST", "/sample/saveSample.do?param01=param01", data, function(result) {
            console.log("성공.");
            alert("result.id  => " + result.data[0].id);
            
            // 선택된 rowIndex, cellIndex 를 가져옴.
            var arrayCell = AUIGrid.getSelectedItems(); // [rowIndex, cellIndex]
            
            // [변경 예제]
            /*
            // 0번째 행의 name 칼럼의 값을 "이름 고침" 으로 변경
            AUIGrid.setCellValue(myGridID, 0, "name", "이름 고침");
            // 3번째 행의 1 번째 칼럼 즉, (3, 1) 의 셀의 값을 "이름 고침" 으로 변경
            AUIGrid.setCellVAlue(myGridID, 3, 1, "이름 고침");
            */
            
		    AUIGrid.setCellValue(myGridID, 0, "id", $("#id").val());
		    AUIGrid.setCellValue(myGridID, 0, "name", $("#id").val());
		    AUIGrid.setCellValue(myGridID, 0, "description", $("#description").val());
            
        }, function(jqXHR, textStatus, errorThrown) {
        	alert("실패하였습니다.");
            console.log("실패하였습니다.");
            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
            
            alert(jqXHR.responseJSON.message);
            console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
          
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
            
        });
    }
      
        
    // 저장. -- Form 데이터 직접 JsonObject로 변경.
    function fn_saveJsonObject(){
    	// validation check .
        // ..........
        
        // json 데이터를 만듬.
        var jsonObject = {
             id : $("#id").val(),
             name : $("#name").val(),
             description : $("#description").val(),
             multi : [ $("#multi01").val(), $("#multi02").val() ]
         };
        
        // 공통 ajax 호출.
    	// callback 함수를 별도로 선언 후 실행.
        Common.ajax("POST", "/sample/saveSample", jsonObject, fn_success, fn_fail);
    }
    

	var fn_success = function(result) {
		//Common.ajax("POST", "/sample/saveSample.do?param01=param01", data, function(result) {
		console.log("성공.");
		alert("result.id  => " + result.data[0].id);

		// 선택된 rowIndex, cellIndex 를 가져옴.
		var arrayCell = AUIGrid.getSelectedItems(); // [rowIndex, cellIndex]

		// [변경 예제]
		/*
		// 0번째 행의 name 칼럼의 값을 "이름 고침" 으로 변경
		AUIGrid.setCellValue(myGridID, 0, "name", "이름 고침");
		// 3번째 행의 1 번째 칼럼 즉, (3, 1) 의 셀의 값을 "이름 고침" 으로 변경
		AUIGrid.setCellVAlue(myGridID, 3, 1, "이름 고침");
		 */

		AUIGrid.setCellValue(myGridID, 0, "id", $("#id").val());
		AUIGrid.setCellValue(myGridID, 0, "name", $("#id")
				.val());
		AUIGrid.setCellValue(myGridID, 0, "description", $(
				"#description").val());

	};
		
	var fn_fail = function (jqXHR, textStatus, errorThrown) {
        alert("실패하였습니다.");
        console.log("실패하였습니다.");
        console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
        
        alert(jqXHR.responseJSON.message);
        console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
      
        console.log("status : " + jqXHR.status);
        console.log("code : " + jqXHR.responseJSON.code);
        console.log("message : " + jqXHR.responseJSON.message);
        console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        
    };

    function test(){
        alert("test function call...");
    }
	</script>


        <input type="hidden" name="selectedId" />
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
            
            <!-- grid -->
            <div id="main">
                <div>
                    <!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
                    <div id="grid_wrap" style="width:800px; height:480px; margin:0 auto;"></div>
                </div>
                
                <div class="desc_bottom">
                    <p id="selectionDesc">22</p>
                </div>
                
                <!--
                    multi data sample : https://github.com/marioizquierdo/jquery.serializeJSON?files=1 
                 -->
                <div id="divDetail">
                    <form id="detailForm" method="post" action="">
                        id : <input type="text" id="id" name="id" value="tmp1"/><br/>
                        name : <input type="text" id="name" name="name" value="tmp2"/><br/>
                        description : <input type="text" id="description" name="description" value="tmp3"/><br/>
                        multi : <input type="text" id="multi01" name="multi[]" value="multiValue01한글"/><br/>
                        multi : <input type="text" id="multi02" name="multi[]" value="multiValue02"/><br/>
                        <input type="button" class="btn" onclick="javascript:fn_saveJsonObject();" value="전송[JsonObject]"/>
                        <input type="button" class="btn" onclick="javascript:fn_saveSerializeJSON();" value="전송[SerializeJSON]"/>
                        
                        <br/>
                        <br/>
                        <br/>
                        <!-- 공통 버튼 제어 -->
                        <%@ include file="./buttonA.jsp" %>
                    </form>
                </div>
            </div>
        </div>
