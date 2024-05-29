<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
var supplementGridID;
var supplementItmGridID;
var supplementCategoryId  = "33";

var MEM_TYPE = '${SESSION_INFO.userTypeId}';
var IS_3RD_PARTY = '${SESSION_INFO.userIsExternal}';


$(document).ready(function(){
	createAUIGrid();
    createSupplementItmGrid();

    doGetComboSepa('/common/selectBranchCodeList.do',  '10', ' - ', '' , 'submissionBrnchId', 'M', 'fn_multiComboBranch'); //Branch Code
    doGetComboDataStatus('/status/selectStatusCategoryCdList.do', {selCategoryId : supplementCategoryId, parmDisab : 0}, '', 'submissionStatusId', 'M', 'fn_multiCombo'); // Status


	 if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){

         if("${SESSION_INFO.memberLevel}" =="1"){

             $("#orgCode").val("${orgCode}");
             $("#orgCode").attr("class", "w100p readonly");
             $("#orgCode").attr("readonly", "readonly");

         }else if("${SESSION_INFO.memberLevel}" =="2"){

             $("#orgCode").val("${orgCode}");
             $("#orgCode").attr("class", "w100p readonly");
             $("#orgCode").attr("readonly", "readonly");

             $("#grpCode").val("${grpCode}");
             $("#grpCode").attr("class", "w100p readonly");
             $("#grpCode").attr("readonly", "readonly");

         }else if("${SESSION_INFO.memberLevel}" =="3"){

             $("#orgCode").val("${orgCode}");
             $("#orgCode").attr("class", "w100p readonly");
             $("#orgCode").attr("readonly", "readonly");

             $("#grpCode").val("${grpCode}");
             $("#grpCode").attr("class", "w100p readonly");
             $("#grpCode").attr("readonly", "readonly");

             $("#deptCode").val("${deptCode}");
             $("#deptCode").attr("class", "w100p readonly");
             $("#deptCode").attr("readonly", "readonly");

         }else if("${SESSION_INFO.memberLevel}" =="4"){

             $("#orgCode").val("${orgCode}");
             $("#orgCode").attr("class", "w100p readonly");
             $("#orgCode").attr("readonly", "readonly");

             $("#grpCode").val("${grpCode}");
             $("#grpCode").attr("class", "w100p readonly");
             $("#grpCode").attr("readonly", "readonly");

             $("#deptCode").val("${deptCode}");
             $("#deptCode").attr("class", "w100p readonly");
             $("#deptCode").attr("readonly", "readonly");

             $("#_memCode").val("${SESSION_INFO.userName}");
             $("#_memCode").attr("class", "w100p readonly");
             $("#_memCode").attr("readonly", "readonly");
             $("#_memBtn").hide();

         }
     }


	    AUIGrid.bind(supplementGridID, "cellClick", function(event){
	        //clear data
	        AUIGrid.clearGridData(supplementItmGridID);

	            //Mybatis Separate Param
	            //1. Grid Display Control
	            $("#_itmDetailGridDiv").css("display" , "");

	            var detailParam = {supSubmId : event.item.supSubmId};
	            //Ajax
	            Common.ajax("GET", "/supplement/selectSupplementSubmissionItmList", detailParam, function(result){
	                AUIGrid.setGridData(supplementItmGridID, result);
	                AUIGrid.resize(supplementItmGridID);
	            });
	    });

});

function createAUIGrid(){


    var supplementColumnLayout =  [
                            {dataField : "supSubmSof", headerText : '<spring:message code="supplement.text.eSOFno" />', width : '8%' , editable : false},
                            {dataField : "supSubmStus", headerText : '<spring:message code="supplement.text.submissionStatus" />', width : '8%', editable : false},
                            {dataField : "supSubmDt", headerText : '<spring:message code="supplement.text.submissionDate" />', width : '8%' , editable : false},
                            {dataField : "supSubmBrnch", headerText : '<spring:message code="supplement.text.submissionBranch" />', width : '8%' , editable : false},
                            {dataField : "custName", headerText : '<spring:message code="sal.text.custName" />', width : '8%' , editable : false},
                            {dataField : "supRefNo", headerText : '<spring:message code="supplement.text.supplementReferenceNo" />', width : '15%' , editable : false},
                            {dataField : "memCode", headerText : '<spring:message code="sal.title.text.salesman" />', width : '8%'  , editable : false},
                            {dataField : "memName", headerText : '<spring:message code="sal.text.salPersonName" />', width : '8%' , editable : false},
                            {dataField : "crtUsr", headerText : '<spring:message code="sal.text.createBy" />', width : '8%' , editable : false},
                            {dataField : "crtDt", headerText : '<spring:message code="sal.text.createDate" />', width : '8%' , editable : false},
                            {dataField : "updUsr", headerText : '<spring:message code="sal.text.updateBy" />', width : '8%' , editable : false},
                            {dataField : "updDt", headerText : '<spring:message code="sal.text.updateDate" />', width : '8%' , editable : false},
                            {dataField : "supSubmId", visible : false}
                            /* ,
                            {dataField : "custId", visible : false},
                            {dataField : "memId", visible : false},
                            {dataField : "supRefId", visible : false},
                            {dataField : "nric", visible : false},
                            {dataField : "atchFileGrpId", visible : false} */
                           ];

    //그리드 속성 설정
    var gridPros = {

            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
       //     selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };

    supplementGridID = GridCommon.createAUIGrid("#supplement_grid_wrap", supplementColumnLayout,'', gridPros);
}

function createSupplementItmGrid(){
    var supplementItmColumnLayout =  [
                                {dataField : "stkCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '10%' , editable : false},
                                {dataField : "stkDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '60%' , editable : false},
                                {dataField : "supSubmItmQty", headerText : '<spring:message code="sal.title.qty" />', width : '10%' , editable : false},
                                {dataField : "supSubmItmUntprc", headerText : '<spring:message code="sal.title.unitPrice" />', width : '10%' , dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                {dataField : "supSubmTotAmt", headerText : '<spring:message code="sal.text.totAmt" />', width : '10%', dataType : "numeric", formatString : "#,##0.00" , editable : false},
                               	{dataField : "supSubmItmId", visible : false},
                               	{dataField : "supSubmId", visible : false}
                           ];
     //그리드 속성 설정
    var itmGridPros = {

            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
  //          selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };

    supplementItmGridID = GridCommon.createAUIGrid("#supplement_itm_grid_wrap", supplementItmColumnLayout,'', itmGridPros);  // address list
}


$(function(){
	$('#_memBtn').click(function() {
        //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
        Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });
    $('#_memCode').change(function(event) {
        var memCd = $('#_memCode').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
        	fn_loadSupplementSalesman(memCd);
        }
    });
    $('#_memCode').keydown(function (event) {
        if (event.which === 13) {    //enter
            var memCd = $('#_memCode').val().trim();

            if(FormUtil.isNotEmpty(memCd)) {
            	fn_loadSupplementSalesman(memCd);
            }
            return false;
        }
    });
    $('#_btnSearch').click(function() {
    	if(fn_validSearchList()) fn_getSupplementSubmissionList();
    });

    $("#newSubmission").click(function() {
    	Common.popupDiv("/supplement/supplementSubmissionAddPop.do",'', null , true , '_insDiv');
    });

    $("#submissionView").click(function() {

    	rowIdx = AUIGrid.getSelectedIndex(supplementGridID)[0];
    	if(rowIdx > -1) {
    	Common.popupDiv("/supplement/supplementSubmissionViewApprovalPop.do", {
	    	supSubmId : AUIGrid.getCellValue(supplementGridID, rowIdx, "supSubmId") , modValue : "view"
	    	}, null , true , '_insDiv');
    	}else{
    		Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
    		return false;
    	}
    });

    $("#submissionApproval").click(function() {

    	rowIdx = AUIGrid.getSelectedIndex(supplementGridID)[0];

    	if(rowIdx > -1) {
        	var stusCode = AUIGrid.getCellValue(supplementGridID, rowIdx, "supSubmStus");

            if(stusCode != 'ACT'){
                Common.alert('<spring:message code="supplement.alert.approvalDisallow" />');
                return false;
            }

    	Common.popupDiv("/supplement/supplementSubmissionViewApprovalPop.do", {
	    	supSubmId : AUIGrid.getCellValue(supplementGridID, rowIdx, "supSubmId") , modValue : "approval"
	    	}, null , true , '_insDiv');

    	}else{
    		Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
    		return false;
    	}

    });

    $("#submissionCancel").click(function() {

    	rowIdx = AUIGrid.getSelectedIndex(supplementGridID)[0];
    	if(rowIdx > -1) {
        	var stusCode = AUIGrid.getCellValue(supplementGridID, rowIdx, "supSubmStus");

            if(stusCode != 'ACT'){
                Common.alert('<spring:message code="supplement.alert.cancelDisallow" />');
                return false;
            }

            Common.popupDiv("/supplement/supplementSubmissionViewApprovalPop.do", {
    	    	supSubmId : AUIGrid.getCellValue(supplementGridID, rowIdx, "supSubmId") , modValue : "cancel"
    	    	}, null , true , '_insDiv');

    	}else{
    		Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
    		return false;
    	}
    });

});

function fn_validSearchList() {
	var isValid = true, msg = "";

    if((!FormUtil.isEmpty($('#submissionStartDt').val()) && FormUtil.isEmpty($('#submissionEndDt').val()))
            || (FormUtil.isEmpty($('#submissionStartDt').val()) && !FormUtil.isEmpty($('#submissionEndDt').val())))
           {
                  msg += '<spring:message code="supplement.alert.msg.selectSubmissionDate" /><br/>';
                  isValid = false
           }

    if(FormUtil.isEmpty($('#_memCode').val())
		    && FormUtil.isEmpty($('#custNric').val())
		    && FormUtil.isEmpty($('#supplementReferenceNo').val())
		    && (FormUtil.isEmpty($('#submissionStartDt').val()) || FormUtil.isEmpty($('#submissionEndDt').val()))
    ){

		if(FormUtil.isEmpty($('#eSOFNo').val())){
			isValid = false;
			msg += '<spring:message code="sal.alert.msg.selSofNo" /><br/>';
		}
	 }

    if(!isValid) Common.alert('<spring:message code="supplement.text.supplementSubmissionSrch" />' + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

     return isValid;

}

function fn_getSupplementSubmissionList() {
	//console.log($("#searchForm").serialize());
    Common.ajax("GET", "/supplement/selectSupplementSubmissionJsonList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(supplementGridID, result);
    });
}

function fn_loadSupplementSalesman(memCode) {

    Common.ajax("GET", "/supplement/selectMemberByMemberIDCode.do", {memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            $('#_memCode').val(memInfo.memCode);
            $('#_memName').val(memInfo.name);            }
    });
}

function fn_loadOrderSalesman(memId,memCode) {

    Common.ajax("GET", "/supplement/selectMemberByMemberIDCode.do", {memId : memId , memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            $('#_memCode').val(memInfo.memCode);
            $('#_memName').val(memInfo.name);            }
    });
}

function fn_multiComboBranch(){
    if ($("#submissionBrnchId option[value='${SESSION_INFO.userBranchId}']").val() === undefined) {
        $('#submissionBrnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        }).multipleSelect("enable");
       //$('#submissionBrnchId').multipleSelect("checkAll");
    } else {
        if ('${PAGE_AUTH.funcUserDefine3}' == "Y") {
            $('#submissionBrnchId').change(function() {
                //console.log($(this).val());
            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '100%'
            }).multipleSelect("enable");
           //$('#submissionBrnchId').multipleSelect("checkAll");
        } else {
          $('#submissionBrnchId').change(function() {
              //console.log($(this).val());
          }).multipleSelect({
              selectAll: true, // 전체선택
              width: '100%'
          }).multipleSelect("disable");
          $("#submissionBrnchId").multipleSelect("setSelects", ['${SESSION_INFO.userBranchId}']);
        }
    }
}

function fn_multiCombo(){
    $('#submissionStatusId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    //$('#submissionStatusId').multipleSelect("checkAll");

}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }

        if(MEM_TYPE == "1" || MEM_TYPE == "2" || MEM_TYPE == "7" ){

            if("${SESSION_INFO.memberLevel}" =="1"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="2"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="3"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="4"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

                $("#_memCode").val("${SESSION_INFO.userName}");
                $("#_memCode").attr("class", "w100p readonly");
                $("#_memCode").attr("readonly", "readonly");
                $("#_memBtn").hide();

            }
        }


    });
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code="supplement.title.healthSupplement"/></li>
    <li><spring:message code="supplement.title.supplementSubmission"/></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="supplement.title.supplementSubmission"/></h2>
<ul class="right_btns">
  <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="newSubmission"><spring:message code="supplement.btn.newSubmission" /></a></p></li>
  </c:if>
  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="submissionApproval"><spring:message code="supplement.btn.submissionApproval" /></a></p></li>
  </c:if>
  <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="submissionCancel"><spring:message code="supplement.btn.submissionCancel" /></a></p></li>
  </c:if>
  <c:if test="${PAGE_AUTH.funcView == 'Y'}">
  	<li><p class="btn_blue"><a href="#" id="submissionView"><spring:message code="supplement.btn.submissionView" /></a></p></li>
    <li><p class="btn_blue"><a href="#" id="_btnSearch"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
  </c:if>
  <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form  id="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
<th scope="row"><spring:message code="sal.text.salManCode" /></th>
	<td colspan = "5" width = "">
		<p><input id="_memCode" name="_memCode" type="text" title="" placeholder="" style="width:100px;" class="" /></p>
		<p><a id="_memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
		<p><input id="_memName" name="_memName" type="text" title="" placeholder="" style="width:500px;" class="readonly" readonly/></p>
	</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
    <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
    <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
</tr>
<tr>
<th scope="row"><spring:message code="supplement.text.submissionDate" /></th>
<td>
	<div class="date_set w100p"><!-- date_set start -->
    <p><input id="submissionStartDt" name="submissionStartDt" type="text" value="${bfDay}" title="Create Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input id="submissionEndDt" name="submissionEndDt" type="text" value="${toDay}" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div>
</td>
<th scope="row"><spring:message code="supplement.text.submissionStatus"/></th>
	<td><select id="submissionStatusId" name="submissionStatusId" class="multy_select w100p" multiple="multiple"></select>
</td>
<th scope="row"><spring:message code="supplement.text.submissionBranch"/></th>
	<td><select id="submissionBrnchId" name="submissionBrnchId" class="multy_select w100p" multiple="multiple"></select>
</td>
</tr>
<tr>
<th scope="row"><spring:message code="supplement.text.eSOFno"/></th>
	<td><input id="eSOFNo" name="eSOFNo" type="text" title="" placeholder="eSOF No" class="w100p" /></td>
<th scope="row"><spring:message code="sal.text.custName"/></th>
	<td><input id="custName" name="custName" type="text" title="" placeholder="Customer Name" class="w100p" /></td>
<th scope="row"><spring:message code="sal.text.nricCompanyNo"/></th>
	<td><input id="custNric" name="custNric" type="text" title="" placeholder="NRIC/Company No" class="w100p" /></td>
</tr>
<tr>
<th scope="row"><spring:message code="supplement.text.supplementReferenceNo"/></th>
	<td><input id="supplementReferenceNo" name="supplementReferenceNo" type="text" title="" placeholder="Supplement Reference No" class="w100p" /></td>
<th scope="row">
	<%-- <spring:message code="sal.text.product"/> --%>
	</th>
	<td>
	<!-- <select id="submissionProductList" name="submissionProductList" class="multy_select w100p" multiple="multiple"></select> -->
	</td>
<th>
</th>
<td>
</td>
</tr>

</tbody>
</table><!-- table end -->

 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt><spring:message code="sal.title.text.link" /></dt>
    <dd>
    <ul class="btns">

    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="supplement_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<!--item Grid  -->
<div id="_itmDetailGridDiv">
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.itmList" /></h3>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="supplement_itm_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</div>

</section><!-- search_result end -->
</section><!-- content end -->
<hr />
