<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
	var nonIncenGridID;
	var uploadId;
	var stusId;
	var typeId;


	$(document).ready(function() {

       	//multiselect setting
        $(function(){
        	var mamData = [];
            var statusData = [];
        	Common.ajax("GET", "/commission/calculation/searchMemTypeList3", $("#myForm").serialize(), function(result) {
        		for(var i=0; i<result.length; i++){
        			mamData[i] = {"codeId" : result[i].cdid, "codeName" : result[i].cdnm};
        		}
		        doDefCombo(mamData, '' ,'memberTypeList', 'M', 'mam_multiCombo');
            });
        	 Common.ajax("GET", "/commission/calculation/searchStatusList", $("#myForm").serialize(), function(result) {
        		 for(var i=0; i<result.length; i++){
        			   statusData[i] = {"codeId" : result[i].stusCodeId, "codeName" : result[i].codeName};
        		 }
		        doDefCombo(statusData, '' ,'statusList', 'M', 'status_multiCombo');
            });


        });
        /* var typeData = [];
        typeData = [{"codeId": "6465","codeName": "Cody/HP/HT Non Monetary Incentive"}];
        doDefCombo(type, '' ,'typeList', 'M', 'type_multiCombo'); */


        createAUIGrid();

		AUIGrid.setSelectionMode(nonIncenGridID, "singleRow");
        // cellClick event.
        AUIGrid.bind(nonIncenGridID, "cellClick", function(event) {
              console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
              uploadId = AUIGrid.getCellValue(nonIncenGridID, event.rowIndex, "uploadId");
              stusId = AUIGrid.getCellValue(nonIncenGridID, event.rowIndex, "stusId");
              typeId = AUIGrid.getCellValue(nonIncenGridID, event.rowIndex, "memTypeId");
        });

      //incentive List search
        $("#search").click(function(){
            Common.ajax("POST", "/commission/calculation/selectAdvIncentiveTargetList", $("#myForm").serializeJSON(), function(result) {
                console.log("성공.");
                console.log("data : " + result);
                uploadId = "";
                stusId = "";
                AUIGrid.setGridData(nonIncenGridID, result);
            });
        });

        $('#actionDate').on('click', function () {
        	$("#actionDate").val("");
        });
        $('#uploadDateFr').on('click', function () {
            $("#uploadDateFr").val("");
        });
        $('#uploadDateTo').on('click', function () {
            $("#uploadDateTo").val("");
        });

	});

	function createAUIGrid() {
        var columnLayout = [ {
            dataField : "uploadId",
            headerText : "Batch ID",
            style : "my-column",
            editable : false
        },{
            dataField : "name",
            headerText : "Status",
            style : "my-column",
            editable : false
        },{
            dataField : "codeName",
            headerText : "Type",
            style : "my-column",
            editable : false
        },{
            dataField : "actnDt",
            headerText : "Target Month",
            style : "my-column",
            editable : false
        },{
            dataField : "c1",
            headerText : "UpLoader",
            style : "my-column",
            editable : false
        },{
            dataField : "crtDt",
            headerText : "Upload Date",
            style : "my-column",
            editable : false
        },{
            dataField : "stusId",
            style : "my-column",
            editable : false,
            visible : false

       },{
           dataField : "memTypeId;",
           style : "my-column",
           editable : false,
           visible : false
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

        nonIncenGridID = AUIGrid.create("#grid_wrap", columnLayout,gridPros);
   }

	//multiselect setting function
	function mam_multiCombo() {
        $(function() {
            $('#memberTypeList').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            }).multipleSelect("checkAll");
        });
    }
	function status_multiCombo() {
        $(function() {
            $('#statusList').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            }).multipleSelect("setSelects", [1]);
        });
    }
	function type_multiCombo() {
        $(function() {
            $('#typeList').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            }).multipleSelect("checkAll");
        });
    }

	//incentive new upload pop
	function newUploadPop(){
		var valTemp = {"mstCodeNm" : "Cody/HP/HT Advance Incentive"};
		Common.popupDiv("/commission/calculation/advanceUploadNewPop.do",valTemp);
	}

	//incentive confirm pop
	function confirmUploadPop(){
		if(uploadId == null || uploadId == ""){
			Common.alert('<spring:message code="commission.alert.nonIncentive.noSelect"/>');
			//Common.alert("No upload batch selected.");
		}else{
			if(stusId != "1"){
				Common.alert('<spring:message code="commission.alert.nonIncentive.noActive"/>');
				//Common.alert("This upload batch "+uploadId+" is no longer active.<br />Confirm batch is disallowed.</b>");
	        }else{
	            var valTemp = {"uploadId" : uploadId, "typeId" : typeId};
	            Common.popupDiv("/commission/calculation/commAdvIncntiveConfirmPop.do",valTemp);
	        }
		}
	}

	//incentive confirm view
	function uploadViewPop(){
        if(uploadId == null || uploadId == ""){
        	Common.alert('<spring:message code="commission.alert.incentive.noSelect"/>');
        	//Common.alert("No upload batch selected.");
        }else{
            var valTemp = {"uploadId" : uploadId};
            Common.popupDiv("/commission/calculation/commAdvIncntivViewPop.do",valTemp);
        }
    }

	//clear button
	function fn_clearSearchForm(){
		$("#myForm")[0].reset();
		mam_multiCombo();
		status_multiCombo();
		type_multiCombo();
	}
</script>
<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Commission</li>
		<li>Non-Monetary Incentive</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Advance Incentive</h2>
		<ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
					</p></li>
            </c:if>
			<li><p class="btn_blue">
					<a href="javascript:fn_clearSearchForm();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a>
				</p></li>
		</ul>
	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form action="#" method="post" name="myForm" id="myForm">

			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 120px" />
					<col style="width: *" />
					<col style="width: 120px" />
					<col style="width: *" />
					<col style="width: 120px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code='commission.text.search.batchId'/></th>
						<td><input type="text" title="" placeholder="Batch ID" class="w100p" name="uploadId" id="uploadId" ' maxlength="20"/></td>
						<th scope="row"><spring:message code='commission.text.search.batchStatus'/></th>
						<td><select class="multy_select w100p" multiple="multiple" name="statusList[]" id="statusList">
						</select></td>
						<th scope="row"><spring:message code='commission.text.search.uploadType'/></th>
						<td>
						<!-- <select class="multy_select w100p" multiple="multiple" name="typeList[]" id="typeList">
						</select> -->
						<select class="multy_select w100p" multiple="multiple" id="typeList" name="typeList">
                              <c:forEach var="list" items="${type}" varStatus="status">
                                  <option value="${list.cdid}">${list.cdnm}</option>
                              </c:forEach>
                          </select>
						</td>
					</tr>
					<tr>
						<th><spring:message code='commission.text.search.targetMonth'/></th>
						<td><input type="text" title="기준년월" placeholder="MM/YY" class="j_date2 w100p" name="actionDate" id="actionDate" /></td>
						<th><spring:message code='commission.text.search.uploadDate'/></th>
						<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="uploadDateFr" id="uploadDateFr" />
						<p>To</p> <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="uploadDateTo" id="uploadDateTo" /></td>
						<th><spring:message code='commission.text.search.uploader'/></th>
						<td><input type="text" title="" placeholder="Uploader (Username)" class="w100p" name="creator" id="creator" / maxlength="20"></td>
					</tr>
					<tr>
						<th><spring:message code='commission.text.search.orgType'/></th>
						<td><select class="multy_select w100p" multiple="multiple" name="memberTypeList[]" id="memberTypeList">
						</select></td>
						<th></th>
						<td></td>
						<th></th>
						<td></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<aside class="link_btns_wrap">
				<!-- link_btns_wrap start -->
				<p class="show_btn">
					<a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
				</p>
				<dl class="link_list">
					<dt>Link</dt>
					<dd>
						<ul class="btns">
                            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
								<li><p class="link_btn">
										<a href="javascript:confirmUploadPop();">Confirm Upload</a>
									</p></li>
							</c:if>
							<c:if test="${PAGE_AUTH.funcView == 'Y'}">
								<li><p class="link_btn">
										<a href="javascript:uploadViewPop();">View Upload Batch</a>
									</p></li>
                            </c:if>
						</ul>
						<ul class="btns">
                            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
								<li><p class="link_btn type2">
										<a href="javascript:newUploadPop();">New Upload</a>
									</p></li>
                            </c:if>
						</ul>
						<p class="hide_btn">
							<a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
						</p>
					</dd>
				</dl>
			</aside>
			<!-- link_btns_wrap end -->

		</form>
	</section>
	<!-- search_table end -->

	<section class="search_result">
		<!-- search_result start -->

		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->

	</section>
	<!-- search_result end -->

</section>
<!-- content end -->

<hr />

</body>
</html>