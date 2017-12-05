<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
/* 드랍 리스트 왼쪽 정렬 재정의*/                      
.aui-grid-drop-list-ul {
    list-style:none;
    margin:0;
    padding:0;
    text-align:left;
}
.aui-grid-drop-list-content {
    display: inline-block;
    border-radius: 0px;
    margin: 0;
    padding: 0;
    cursor: pointer;
    overflow: hidden;
    font-size: 1em;
    line-height: 2em;
    vertical-align: top;
    text-align: left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
</style>

    <script type="text/javaScript" language="javascript">
    
        // AUIGrid 생성 후 반환 ID
       var myGridID;
           var option = {
           width : "1000px", // 창 가로 크기
           height : "600px" // 창 세로 크기
       };
            var  branchList =[];
            var  ctCodeList = [];
    
            function createAUIGrid(){
		        // AUIGrid 칼럼 설정
		        var columnLayout = [ {
		        
			        dataField : "promoId",
			        headerText : "Branch",
			        width : 120
		        }];
		        
		     

			// AUIGrid 칼럼 설정
			var columnLayout = [
			       
					{
					    dataField : "code",
					    headerText : "Branch",
					    width: 280,
					    editenderer : {
					        type : "DropDownListRenderer",
					        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
					        descendants : [ "memCode" ], // 자손 필드들
					        descendantDefaultValues : [ "-" ], // 변경 시 자손들에게 기본값 지정
					        list : branchList,
					        keyField   : "codeId", //key 에 해당되는 필드명
		                    valueField : "codeName"        //value 에 해당되는 필드명
					    },
					    style : "aui-grid-user-custom-left",
                        editable : false
					}, {
					    dataField : "memCode",
					    headerText : "CT",
					    width: 280,
					    editenderer : {
					        type : "DropDownListRenderer",
					        showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
					        listFunction : function(rowIndex, columnIndex, item, dataField) {
					        	return ctCodeList;
				            },
							keyField   : "memId", //key 에 해당되는 필드명
		                    valueField : "memCode"        //value 에 해당되는 필드명
					    },
					    style : "aui-grid-user-custom-left",
                        editable : false
					},
			        {
			            	dataField : "codeId",
			                headerText : "Branch1",
			                width: 0
			        }, {
				        	dataField : "memId",
			                headerText : "CT1",
			                width: 0
			        }, {
            	
            	
			        headerText : "Morning",
			        children : [
			            {
			                    dataField: "morngSesionAs",
			                    headerText: "AS",
			                    width:60
			            }, {
			                    dataField: "morngSesionIns",
			                    headerText: "INS",
			                    width:60
			            }, {
			                    dataField: "morngSesionRtn",
			                    headerText: "RTN",
			                    width:60
			            }
			        ]
			}, {
			        headerText : "Afternoon",
			        children : [
			            {
			                    dataField: "aftnonSesionAs",
			                    headerText: "AS",
			                    width:60,
			            }, {
			                    dataField: "aftnonSesionIns",
			                    headerText: "INS",
			                    width:60
			            }, {
			                    dataField: "aftnonSesionRtn",
			                    headerText: "RTN",
			                    width:60
			            }
			        ]
			},{
			        headerText : "Evening",
			        children : [
			            {
			                    dataField: "evngSesionAs",
			                    headerText: "AS",
			                    width:60 
			            }, {
			                    dataField: "evngSesionIns",
			                    headerText: "INS",
			                    width:60
			            }, {
			                    dataField: "evngSesionRtn",
			                    headerText: "RTN",
			                    width:60
			            }
			        ]
			}];




            
            // 그리드 속성 설정
            var gridPros = {
                
                // 페이징 사용       
                usePaging : true,
                
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                pageRowCount : 20,
                
                editable : true,
                
                displayTreeOpen : true,
                
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true,
                
                showStateColumn : false
        
            };

                 myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

                 
    }
    
    
     // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){
       // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        fn_getCtCodeSearch1();
        //fn_getCtCodeSearch('');
        
        // 171114 :: 선한이
	    $("#cmbbranchId").change(function (){
	        
	        doGetCombo('/organization/seleCtCodeSearch2.do',  $("#cmbbranchId").val(), '','cmbctId', 'S' ,  '');
	    });
    
     // 에디팅 정상 종료, 취소 이벤트 바인딩
        AUIGrid.bind(myGridID, ["cellEditEnd", "cellEditCancel"], auiCellEditingHandler);
    });
     
    // 편집 핸들러
    function auiCellEditingHandler(event) {
       //document.getElementById("ellapse").innerHTML = event.type  + ": ( " + event.rowIndex  + ", " + event.columnIndex + ") : " + event.value;
        
         var item = new Object();
	        item.codeId="";
	        item.memId="";
	        
        if(event.columnIndex  ==0){
        	fn_getCtCodeSearch(event.value);
            AUIGrid.setCellValue(myGridID, event.rowIndex , "codeId", event.value);
            AUIGrid.setCellValue(myGridID, event.rowIndex , "memId", "");
            
        }
        
        if(event.columnIndex  ==1){
        	  AUIGrid.setCellValue(myGridID, event.rowIndex , "memId", event.value);
        	  if(event.value == '0'){
        		  //fn_getCtCodeSearch(AUIGrid.getCellValue(myGridID, event.rowIndex ,2));
        	  }
        	  //fn_getCtCodeSearch(AUIGrid.getCellValue(myGridID, event.rowIndex ,0));
         }
        console.log(event);
    };


    // 리스트 조회.
		function fn_getSsCapacityBrListAjax() {        
		    Common.ajax("GET", "/organization/selectSsCapacityCtList", $("#searchForm").serialize(), function(result) {
		        
		        console.log("성공.");
		        console.log("data : " + result);
		        AUIGrid.setGridData(myGridID, result);
		    });
		}
		var bobj = new Object();
		
		function addRow() {
			
			if($("#cmbbranchId").val() == ''){
                Common.alert("Please Select Branch Type");
                return false;
            }
			
			if($("#cmbctId").val() == ''){
                Common.alert("Please Select CT Code");
                return false;
            }
			
	         var item = new Object();
	         item.brnchId1="";
	         item.ctId1="";
	         item.code="";
	         item.memCode="";
	         item.morngSesionAs="";
	         item.morngSesionIns="";
	         item.morngSesionRtn="";
	         item.aftnonSesionAs="";
	         item.aftnonSesionIns="";
	         item.aftnonSesionRtn="";
	         item.evngSesionAs="";
	         item.evngSesionIns="";
	         item.evngSesionRtn="";
	         
	         //fn_getCtCodeSearch1();
	         
	         bobj = new Object();
	         if($("#cmbbranchId option:selected").val() == ''){
	        	 //fn_getCtCodeSearch1();
	         }else{
	        	 item.code =  $("#cmbbranchId option:selected").text();
	        	 item.brnchId1 = $("#cmbbranchId option:selected").val();
	        	 item.codeId = $("#cmbbranchId option:selected").val();
	        	 if($("#cmbctId option:selected").val() != ''){
	            	 item.memCode =  $("#cmbctId option:selected").text();
	            	 item.ctId1 =  $("#cmbctId option:selected").val();
	            	 item.memId =  $("#cmbctId option:selected").val();
	             }
		        
	        } 
	         
	         AUIGrid.addRow(myGridID, item, "first");
	     }
    
    function fn_save(){
    	
    	Common.ajax("POST", "/organization/saveCapacity.do", GridCommon.getEditData(myGridID), function(result) {
            console.log("성공.");
            console.log("data : " + result);
        });
    }
    
    function removeRow(){
    	 var selectedItems = AUIGrid.getSelectedItems(myGridID);
         
         if(selectedItems.length <= 0 ){
               Common.alert("There Are No selected Items.");
               return ;
         }
         
        AUIGrid.removeRow(myGridID, "selectedIndex");
        AUIGrid.removeSoftRows(myGridID);
    }
    
    function fn_excelDown(){
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("grid_wrap", "xlsx", "CT Session Capacity");
    }
    
    function fn_getCtCodeSearch(_brnch){
        Common.ajax("GET", "/organization/seleCtCodeSearch.do",{brnch:_brnch}, function(result) {
        	ctCodeList = result;
        }, null, {async : false});
    }
    
    function fn_getCtCodeSearch1(){
        Common.ajax("GET", "/organization/seleBranchCodeSearch.do",{groupCode:'43'}, function(result) {
        	for( i in result){
        	    console.log(result[i]);
        		branchList.push(result[i]);
        	}
        }, null, {async : false});
    }
    
    // 171204 :: 선한이
    // 엑셀 업로드
    function fn_uploadFile() {
        var formData = new FormData();
          console.log("read_file: " + $("input[name=uploadfile]")[0].files[0]);
          formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
          
        Common.ajaxFile("/organization/excel/saveCapacityByExcel.do"
                  , formData
                  , function (result) 
                   {
                        //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                        if(result.code == "99"){
                            Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
                        }else{
                            Common.alert(result.message);
                        }
               });
    };

    
    </script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>CT Session Capacity</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="searchForm">

<aside class="title_line"><!-- title_line start -->
<h3>Search Option</h3>
<ul class="right_btns">

    <!-- 171204 :: 선한이 -->
    <li>
    <div class="auto_file"><!-- auto_file start -->
    <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".xlsx"/>
    </div><!-- auto_file end -->
    </li>
    <li><p class="btn_blue"><a onclick="javascript:fn_uploadFile()">Update Request</a></p></li>

    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getSsCapacityBrListAjax();"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Branch</th>
    <td>

     <select id="cmbbranchId" name="cmbbranchId" class="w100p" style='text-align:left' >
        <option value="">Choose One</option>
         <c:forEach var="list" items="${dscBranchList }">
            <option value="${list.brnchId }" style='text-align:left'>${list.brnchName }</option>
         </c:forEach>
     </select>

    </td>
    <th scope="row">CT Code</th>
    <td>
    <select id="cmbctId" name="cmbctId" class="w100p" style='text-align:left'>
        <%-- <option value="">Choose One</option>
         <c:forEach var="list" items="${ssCapacityCtList2 }">
            <option value="${list.memId }">${list.memCode }</option>
         </c:forEach> --%>
     </select>
    </td>
    <th scope="row">Status</th>
    <td>
        <select id="status" name="status" class="w100p" style='text-align:left' >
            <option value="">Choose One</option>
            <option value="Active">Active</option>
            <option value="Complete">Complete</option>
        </select>
    </td>
    <!-- <td>
    <div class="search_100p">search_100p start
    <input type="text" title="" placeholder="" class="w100p"/>
    <a href="#" class="search_btn"></a>
    </div>search_100p end

    </td> -->
</tr>
</tbody>
</table><!-- table end -->

<!-- <aside class="link_btns_wrap">link_btns_wrap start
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside>link_btns_wrap end
 -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h3>CT Capacity Configuration</h3>
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="fn_excelDown()">EXCEL DW</a></p></li>
    <!-- <li><p class="btn_grid"><a href="#" onclick="removeRow()">DEL</a></p></li> -->
    <li><p class="btn_grid"><a href="#" onclick="fn_save()">SAVE</a></p></li>
    <!-- <li><p class="btn_grid"><a href="#" onclick="addRow()">ADD</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

    