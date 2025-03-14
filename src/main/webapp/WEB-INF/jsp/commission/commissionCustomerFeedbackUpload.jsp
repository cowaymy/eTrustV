<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
	var incenGridID;
	var uploadId;
	var stusId;
	var typeId;


	$(document).ready(function() {

        $(function(){
        	var memData = [];
            var statusData = [];
            doGetCombo('/common/selectCodeList.do', '1', '2'  ,'memberTypeList', 'S' , '');

        	 Common.ajax("GET", "/commission/calculation/searchStatusList", $("#myForm").serialize(), function(result) {
        		 for(var i=0; i<result.length; i++){
        			   statusData[i] = {"codeId" : result[i].stusCodeId, "codeName" : result[i].codeName};
        		 }
		        doDefCombo(statusData, '' ,'statusList', 'M', 'status_multiCombo');
            });

        });

        createAUIGrid();

		AUIGrid.setSelectionMode(incenGridID, "singleRow");
        AUIGrid.bind(incenGridID, "cellClick", function(event) {
              uploadId = AUIGrid.getCellValue(incenGridID, event.rowIndex, "uploadId");
              stusId = AUIGrid.getCellValue(incenGridID, event.rowIndex, "stusId");
              typeId = AUIGrid.getCellValue(incenGridID, event.rowIndex, "memTypeId");
        });

        $("#search").click(function(){
            Common.ajax("POST", "/commission/calculation/selectCFFList", $("#myForm").serializeJSON(), function(result) {
                uploadId = "";
                stusId = "";
                AUIGrid.setGridData(incenGridID, result);
            });
        });

        $('#actionDate').click(function() {$("#actionDate").val("");});
        $('#uploadDateFr').click(function() {$("#uploadDateFr").val("");});
        $('#uploadDateTo').click(function() {$("#uploadDateTo").val("");});

	});

	function createAUIGrid() {
        var columnLayout = [
	         {dataField : "uploadId",headerText : "Batch ID",style : "my-column",editable : false}
	        ,{dataField : "name",headerText : "Status",style : "my-column",editable : false}
	        ,{dataField : "actnDt",headerText : "Target Month",style : "my-column",editable : false}
	        ,{dataField : "c1",headerText : "UpLoader",style : "my-column",editable : false}
	        ,{dataField : "crtDt",headerText : "Upload Date",style : "my-column",editable : false}
	        ,{dataField : "stusId",style : "my-column",editable : false,visible : false}
	        ,{dataField : "memTypeId;",style : "my-column",editable : false,visible : false}
        ];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true
        };

        incenGridID = AUIGrid.create("#grid_wrap", columnLayout,gridPros);
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

	//incentive new upload pop
	function newUploadPop(){
		Common.popupDiv("/commission/calculation/commCFFUploadNewPop.do");
	}

	//incentive confirm pop
	function confirmUploadPop(){
		if(uploadId == null || uploadId == ""){
			Common.alert('<spring:message code="commission.alert.incentive.noSelect"/>');
			//Common.alert("No upload batch selected.");
		}else{
			if(stusId != "1"){
				Common.alert('<spring:message code="commission.alert.incentive.noActive"/>');
				//Common.alert("This upload batch "+uploadId+" is no longer active.<br />Confirm batch is disallowed.</b>");
	        }else{
	            var valTemp = {"uploadId" : uploadId, "typeId" : typeId};
	            Common.popupDiv("/commission/calculation/commCFFConfirmPop.do",valTemp);
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
            Common.popupDiv("/commission/calculation/commCFFViewPop.do",valTemp);
        }
    }

	//clear button
	function fn_clearSearchForm(){
		$("#myForm")[0].reset();
		status_multiCombo();
		type_multiCombo();
	}
</script>
<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Commission</li>
		<li><spring:message code='commission.title.CFF'/></li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>

		<h2><spring:message code='commission.title.CFF'/></h2>
		<ul class="right_btns">
<%--             <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
				<li><p class="btn_blue">
						<a href="#" id="search"><span class="search"></span><spring:message code='sys.btn.search'/></a>
					</p></li>
<%--             </c:if> --%>
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
						<th><spring:message code='commission.text.search.targetMonth'/></th>
                        <td><input type="text" title="기준년월" placeholder="MM/YY" class="j_date2 w100p" name="actionDate" id="actionDate" /></td>
					</tr>
					<tr>
						<th><spring:message code='commission.text.search.uploadDate'/></th>
						<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="uploadDateFr" id="uploadDateFr" />
						<p>To</p> <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date " name="uploadDateTo" id="uploadDateTo" /></td>
						<th><spring:message code='commission.text.search.uploader'/></th>
						<td><input type="text" title="" placeholder="Uploader (Username)" class="w100p" name="creator" id="creator" / maxlength="20"></td>
						<th><spring:message code='commission.text.search.orgType'/></th>
                        <td>
                        <select id="memberTypeList" name="memberTypeList[]" class="w100p disabled" disabled></select>
                        <input type="hidden" id="memberTypeList" name="memberTypeList[]" value="2" />
                        </td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->
<%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"> --%>
			<aside class="link_btns_wrap">
				<!-- link_btns_wrap start -->
				<p class="show_btn">
					<a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
				</p>
				<dl class="link_list">
					<dt>Link</dt>
					<dd>
						<ul class="btns">
								<li><p class="link_btn">
										<a href="javascript:confirmUploadPop();">Confirm Upload</a>
									</p></li>
								<li><p class="link_btn">
										<a href="javascript:uploadViewPop();">View Upload Batch</a>
									</p></li>
						</ul>
						<ul class="btns">
								<li><p class="link_btn type2">
										<a href="javascript:newUploadPop();">New Upload</a>
									</p></li>
						</ul>
						<p class="hide_btn">
							<a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
						</p>
					</dd>
				</dl>
			</aside>
			<!-- link_btns_wrap end -->
<%-- </c:if> --%>
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