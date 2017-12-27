<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align:left;
    margin-top:-20px;
}
</style>

<script type="text/javaScript">
	var acGridID;
	var siGridID;
	var gridDataLength = 0;

	$(document).ready(function() {
		
		//change orgCombo List
        $("#orgGrCombo").change(function() {
            $("#orgCombo").find('option').each(function() {
                $(this).remove();
            });
            if ($(this).val().trim() == "") {
                return;
            }       
            fn_getOrgCdListAllAjax(); //call orgList
        }); 
		
        $("#searchDt").change(function() {
            $("#orgCombo").find('option').each(function() {
                $(this).remove();
            });
            if ($(this).val().trim() == "") {
                return;
            }       
            fn_getOrgCdListAllAjax(); //call orgList
        }); 
		
		 createActualAUIGrid();
	     createSimulAUIGrid();
	     AUIGrid.setSelectionMode(acGridID, "singleRow");
	     
	  // ready 이벤트 바인딩
        AUIGrid.bind(acGridID, "ready", function(event) {
            gridDataLength = AUIGrid.getGridData(acGridID).length; // 그리드 전체 행수 보관
        });
	  
        // 헤더 클릭 핸들러 바인딩
        AUIGrid.bind(acGridID, "headerClick", function(event) {
            // isExclude 칼럼 클릭 한 경우
            if(event.dataField == "checkFlag") {
                if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
                    var  isChecked = document.getElementById("allCheckbox").checked;
                    checkAll(isChecked);
                }
                return false;
            }
        });
        
        // 셀 수정 완료 이벤트 바인딩
        AUIGrid.bind(acGridID, "cellEditEnd", function(event) {
            
            // isActive 칼럼 수정 완료 한 경우
            if(event.dataField == "checkFlag") {
                
                // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환 
                var activeItems = AUIGrid.getItemsByValue(acGridID, "checkFlag", "1");
                
                // 헤더 체크 박스 전체 체크 일치시킴.
                if(activeItems.length != gridDataLength) {
                    document.getElementById("allCheckbox").checked = false;
                } else if(activeItems.length == gridDataLength) {
                     document.getElementById("allCheckbox").checked = true;
                }
            }
        });
	     
	     $("#search").click(function(){
	    	 Common.ajax("GET", "/commission/system/selectVersionList", $("#searchForm").serialize(), function(result) {
	             console.log("성공.");
	             AUIGrid.setGridData(acGridID, result.actualList);
	             AUIGrid.setGridData(siGridID, result.simulList);
	         });
	     });
	     
	     $("#save").click(function(){
	    	 if(AUIGrid.getGridData(siGridID).length <=0 ){
	    		 //Common.alert("Don't save to no Data");
	    		 Common.setMsg("<spring:message code='commission.alert.version.noSave'/>");
	    	 }else{
	    		 Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridCall);
	    	 }
	    		 
	     });
	     
		$("#clear").click(function(){
			AUIGrid.clearGridData(siGridID);
		});
	});
	function fn_saveGridCall(){
		var gridList = AUIGrid.getGridData(siGridID);       //그리드 데이터
        var formList = $("#searchForm").serializeJSON();
        var data = {};
        data.all = gridList;
        data.form = formList;
        Common.ajax("POST", "/commission/system/saveCommVersionInsert.do", data, function(result) {
            console.log("성공.");
            $("#search").click();
        });
	}
	
    // 전체 체크 설정, 전체 체크 해제 하기
    function checkAll(isChecked) {
        var rowCount = AUIGrid.getRowCount(acGridID);
        
        if(isChecked){   // checked == true == 1
          for(var i=0; i<rowCount; i++){
             AUIGrid.updateRow(acGridID, { "checkFlag" : 1 }, i);
          }
        }else{   // unchecked == false == 0
          for(var i=0; i<rowCount; i++){
             AUIGrid.updateRow(acGridID, { "checkFlag" : 0 }, i);
          }
        }
        
        // 헤더 체크 박스 일치시킴.
        document.getElementById("allCheckbox").checked = isChecked;
    };
	function createActualAUIGrid(){
	    var columnLayout = [ {
	        dataField : "checkFlag",
	        headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
	        width: 35,
	        renderer : {
	            type : "CheckBoxEditRenderer",
	            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	            checkValue : "1", // true, false 인 경우가 기본
	            unCheckValue : "0"
	        }
	    },{
	          dataField : "codeName",
	          headerText : "<spring:message code='commission.text.grid.codeName'/>",
	          style : "my-column",
	          editable : false
	      },{
              dataField : "cdds",
              headerText : "<spring:message code='commission.text.desc'/>",
              style : "my-column",
              editable : false
          },{
              dataField : "itemCd",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "orgSeq",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "itemNm",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "orgGrCd",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "orgCd",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "typeCd",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "useYn",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "itemDesc",
              style : "my-column",
              visible : false,
              editable : false
          },{
              dataField : "startYearmonth",
              style : "my-column",
              visible : false,
              editable : false
          }];
	    
	      // 그리드 속성 설정
	      var gridPros = {
	          
	          // 페이징 사용       
	          usePaging : true,
	          // 한 화면에 출력되는 행 개수 20(기본값:20)
	          pageRowCount : 20,
	          // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	          skipReadonlyColumns : true,
	          // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	          wrapSelectionMove : true,
	          // 줄번호 칼럼 렌더러 출력
	          showRowNumColumn : true
	          
	      };
	      
	      acGridID = AUIGrid.create("#grid_wrap_a", columnLayout,gridPros);
	}
	function createSimulAUIGrid(){
		var columnLayout = [ {
            dataField : "codeName",
            headerText : "<spring:message code='commission.text.grid.codeName'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "cdds",
            headerText : "<spring:message code='commission.text.desc'/>",
            style : "my-column",
            editable : false
        },{
            dataField : "itemSeq",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "itemCd",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "newYn",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "orgSeq",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "itemNm",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "orgGrCd",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "orgCd",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "typeCd",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "useYn",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "itemDesc",
            style : "my-column",
            visible : false,
            editable : false
        },{
            dataField : "startYearmonth",
            style : "my-column",
            visible : false,
            editable : false
        }];
        // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true
            
        };
        
        siGridID = AUIGrid.create("#grid_wrap_s", columnLayout,gridPros);
  
	}

	
    function insertStatusCatalogDetail(){

		//그리드 데이터에서 checkFlag 필드의 값이 Active 인 행 아이템 모두 반환
	    var activeItems = AUIGrid.getItemsByValue(acGridID, "checkFlag", 1);
	    console.log(activeItems);
		 if (activeItems.length < 1){
			Common.alert("<spring:message code='sys.msg.first.Select' arguments='[Actual]' htmlEscape='false'/>");
			return false;
		}
		 
		 if (activeItems.length > 0){
			var rowPos = "first";
			var item = new Object();
			var rowList = [];
			
			var grdCnt = AUIGrid.getGridData(siGridID).length;
			var addYn = true;
			console.log("activeItems : "+ activeItems.length);
            console.log("grdCnt : "+grdCnt);
			for(var j=0 ; j <activeItems.length ; j++){
			    for(var i=0 ; i<grdCnt ; i++){
			//alert(activeItems[j].itemCd);
					if(activeItems[j].itemCd == AUIGrid.getCellValue(siGridID, i, 'itemCd') ){
						    AUIGrid.removeRow(siGridID, i);
						/* if( 'Y' == AUIGrid.getCellValue(siGridID, i, 'newYn') ){
						    Common.alert(activeItems[i].codeName + "는 이미 추가된 아이템입니다."); 
						}else{
							AUIGrid.setCellValue(siGridID, i, "newYn", "N");
						} */
					}
				}
			}
            AUIGrid.removeSoftRows(siGridID);
            
			if(addYn){
				for (var i = 0 ; i < activeItems.length ; i++){
					rowList[i] = {
						codeName : activeItems[i].codeName,
						cdds : activeItems[i].cdds,
						itemCd : activeItems[i].itemCd,
						newYn : 'Y',
						
						orgSeq : activeItems[i].orgSeq,
						itemNm : activeItems[i].itemNm,
						orgGrCd : activeItems[i].orgGrCd,
						orgCd : activeItems[i].orgCd,
						typeCd : activeItems[i].typeCd,
						useYn : activeItems[i].useYn,
						itemDesc : activeItems[i].itemDesc,
						startYearmonth : activeItems[i].startYearmonth
					}
					AUIGrid.addUncheckedRowsByIds(siGridID, activeItems[i].rnum);
				} 
			AUIGrid.addRow(siGridID, rowList, rowPos);
			}
		}            
	  
	} 
    
  //get Ajax data and set organization combo data
    function fn_getOrgCdListAllAjax(callBack) {
        Common.ajaxSync("GET", "/commission/system/selectOrgCdListAll", $("#searchForm").serialize(), function(result) {
            orgList = new Array();
            if (result) {
                $("#orgCombo").append("<option value='' ></option>");
                for (var i = 0; i < result.length; i++) {
                    $("#orgCombo").append("<option value='"+result[i].orgCd + "' > " + result[i].orgNm + "</option>");
                }
            }
            //if you need callBack Function , you can use that function
            if (callBack) {
                callBack(orgList);
            }
        });
    }
</script>


	<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
		<li><spring:message code='commission.text.head.masterMgmt'/></li>
		<li><spring:message code='commission.text.head.ruleBookVersionMgmt'/></li>
	</ul>
	
	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
		  <a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code='commission.title.versionMgmt'/></h2>
		<ul class="right_opt">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
				</p></li>
			</c:if>
		</ul>
	</aside>
	<!-- title_line end -->
	
	<section class="search_table">
	<!-- search_table start -->
		<form id="searchForm" action="" method="post">
		
		<table class="type1">
		<!-- table start -->
		<caption>search table</caption>
		<colgroup>
			<col style="width: 110px" />
			<col style="width: *" />
			<col style="width: 110px" />
			<col style="width: *" />
			<col style="width: 110px" />
			<col style="width: *" />
			<col style="width: 110px" />
			<col style="width: *" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row"><spring:message code='commission.text.search.monthYear'/><span class="must">*</span></th>
				<td>
				<input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width:200px;" />
				</td>
				
				<th scope="row"><spring:message code='commission.text.search.orgGroup'/><span class="must">*</span></th>
				<td>
					<select id="orgGrCombo" name="orgGrCombo" style="width:100px;">
						<c:forEach var="list" items="${orgGrList }">
						<option value="${list.cdid}">${list.cd}</option>
						</c:forEach>
					</select>
				</td>
				
				<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
				<td>
					<select id="orgCombo" name="orgCombo" style="width:100px;">
						<option value=""></option>
						<c:forEach var="list" items="${orgList }">
						<option value="${list.cdid}">${list.cdnm}</option>
						</c:forEach>
					</select>
				</td>
				
				<th scope="row"><spring:message code='commission.text.search.useYN'/></th>
				<td>
					<select id="useYnCombo" name="useYnCombo" style="width:100px;">
						<option value=""></option>
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</td>
			</tr>
		</tbody>
		</table>
		<!-- table end -->
		</form>
	</section>
	<!-- search_table end -->
	
	<section class="search_result">
		<!-- search_result start -->
		<section class="search_result"><!-- search_result start -->
		
			<div class="divine_auto type2"><!-- divine_auto start -->
				
				<div style="width:45%"><!-- 50% start -->
					<aside class="title_line"><!-- title_line start -->
					   <h3><spring:message code='commission.text.search.actual'/></h3>
					</aside><!-- title_line end -->
					<div class="border_box" style="height:330px;"><!-- border_box start -->
						<article class="grid_wrap"><!-- grid_wrap start -->
							<!-- 그리드 영역2 -->
							<div id="grid_wrap_a"></div>
						</article><!-- grid_wrap end -->
						
						<!-- right button -->
						<ul class="btns right-type">
						  <li><a onclick="insertStatusCatalogDetail();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a></li>
						</ul>
						
					</div><!-- border_box end -->
				</div><!-- 50% end -->
				
				<div style="width:55%"><!-- 50% start -->
					<aside class="title_line"><!-- title_line start -->
					   <h3><spring:message code='commission.text.search.simulation'/> </h3>
					   <ul class="right_btns">
				            <li>
				                <p class="btn_grid">
				                    <a href="#" id="clear"><span class="clear"></span><spring:message code='sys.btn.clear'/></a>
				                </p>
				            </li>
				            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
					            <li>
					                <p class="btn_grid">
					                    <a href="#" id="save"><spring:message code='sys.btn.save'/></a>
					                </p>
					            </li>
				            </c:if>
				        </ul>
					</aside><!-- title_line end -->
					<div class="border_box" style="height:330px;"><!-- border_box start -->
						<article class="grid_wrap"><!-- grid_wrap start -->
							<!-- 그리드 영역3 -->
							<div id=grid_wrap_s></div>
						</article><!-- grid_wrap end -->
					</div><!-- border_box end -->
				</div><!-- 50% end -->
			
			
			</div><!-- divine_auto end -->
		
		</section><!-- search_result end -->
		
	
	</section>
	<!-- search_result end -->
	
	</section>
	<!-- content end -->

<!-- container end -->
<hr />

<!-- wrap end -->
</body>
</html>

