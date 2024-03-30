<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#my_grid_wrap-aui-grid-drop-list-taxCode .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
var membercode = "${membercode}";
var selectRowIdx;
var deleteRowIdx;
var expTypeName;
//file action list
var update = new Array();
var remove = new Array();
var newGridColumnLayout = [ {
    dataField : "membercode",
    headerText : "Member Code",
}, {
    dataField : "name",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "nric",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "requestCategory",
    headerText : "Member Code",
}, {
    dataField : "caseCategory",
    headerText : "Member Code",
}, {
    dataField : "telMobile",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "email",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "remark1",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "effectDt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "userName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var newGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 헤더 높이 지정
    headerHeight : 40,
    // 그리드가 height 지정( 지정하지 않으면 부모 height 의 100% 할당받음 )
    height : 175,
    softRemoveRowMode : false,
    rowIdField : "membercode",
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var approvalColumnLayout = [ {
    dataField : "membercode",
    headerText : "Member Code",
}, {
    dataField : "name",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "nric",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "requestCategory",
    headerText : "Request Category",
}, {
    dataField : "caseCategory",
    headerText : "Case Category",
}, {
    dataField : "telMobile",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "email",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "remark1",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "effectDt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "userName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var myGridPros = {
    editable : true,
    softRemoveRowMode : false,
    rowIdField : "membercode",
    headerHeight : 40,
    height : 160,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var myGridID;
var newGridID;
var userName1 = "${SESSION_INFO.userName}";

function fn_checkValidation() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#requestCategory").val())) {
        Common.alert('Please select one Request Category');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#caseCategory").val())) {
        Common.alert('Please select one Case Category');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#remark1").val())) {
        Common.alert('Please key in Remark');
        checkResult = false;
        return checkResult;
    }
    return checkResult;
}



function fn_approveLinePop(memCode, userName, caseCategory) {
    // check request - Request once per user per month
    var requestResultM = {
                     requestCategory : $("#requestCategory").val(),
                     memCode : $("#memCode").val(),
                     caseCategory : $("#caseCategory").val(),
                     remark1 : $("#remark1").val(),
                     effectDt : $("#effectDt").val(),
                     userName : $("#userName").val()
             }

     /* var saveForm = {
             "requestResultM" : requestResultM,
         };
 */
     console.log("requestResultM: " + requestResultM);


    Common.ajax("POST", "/organization/checkExistMemCode.do?_cacheId=" + Math.random(), requestResultM, function(result) {
        console.log(result);
        if(result.data > 0) {
            Common.alert(result.message);
        } else {
            //Common.popupDiv("/organization/approveLinePop.do", {memCode:memCode, userName:userName, caseCategory:caseCategory}, null, true, "approveLineSearchPop");
            Common.popupDiv("/organization/approveLinePop.do", requestResultM, null, true, "approveLineSearchPop");
        }
    });
}

$(document).ready(function () {

	console.log("READY!");


	doGetCombo('/common/selectCodeList.do', '571', '', 'requestCategory', 'S', '');
	doGetCombo('/common/selectCodeList.do', '572', '', 'caseCategory', 'S', '');

    $("#remark1").keyup(function(){
          $("#characterCount").text($(this).val().length + " of 100 max characters");
    });

    var date = new Date();
    $("#newClmMonth").val((date.getMonth() + 1).toString().padStart(2, '0') + "/" + date.getFullYear());

    /* newGridID = AUIGrid.create("#newMemberRequest_grid_wrap", newGridColumnLayout, newGridPros);
    $("#newMemberRequest_grid_wrap").hide(); */
    //myGridID = AUIGrid.create("#my_grid_wrap", approvalColumnLayout, myGridPros);

    AUIGrid.setGridData(newGridID, '${itemList}');
    /* console.log($.parseJSON('${itemList}')) */


    var result = '${itemList}';


    $("#request_btn").click(function() {
        var result = fn_checkValidation();
        if(result) {
            fn_approveLinePop($("#memCode").val(), $("#userName").val(), $("#caseCategory").val());
        }
    });

});



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member Access Information</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newStaffClaim">
<input type="hidden" id="branchNo" name="branchNo" value="${memberAccess.brnchId}" />


<table class="type1"><!-- table start -->
<caption>Access Details</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request Category<span class="must">**</span></th>
    <td>
        <select id="requestCategory" name="requestCategory" class="w100p">
        </select>
    </td>
    <th scope="row"><spring:message code='sal.title.memberCode' /></th>
    <td>
        <input id="memCode" name="memCode" type="text" title="" placeholder="<spring:message code='sal.title.memberCode' />" class="w100p" value="${memberAccess.memCode}" readonly />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sal.text.contactNumber' /></th>
    <td>
        <input type="text" title="" placeholder="<spring:message code='sal.text.contactNumber' />" class="w100p" id="telMobile" name="telMobile" value="${memberAccess.telMobile}"  readonly/>
    </td>
    <th scope="row"><spring:message code='org.member.stus' /></th>
    <td>
        <input type="text" title="" placeholder="<spring:message code='org.member.stus' />" class="w100p" id="name" name="name" value="${memberAccess.name}"  readonly/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sal.text.email' /></th>
    <td>
        <input type="text" title="" placeholder="<spring:message code='sal.text.email' />" class="w100p" id="email" name="email" value="${memberAccess.email}" readonly />
    </td>
    <th scope="row">Case Category<span class="must">**</span></th>
    <td>
        <select id="caseCategory" name="caseCategory" class="w100p">
        </select>
    </td>
</tr>
<tr>
      <th scope="row">Remark <span class="must">**</span></th>
      <td colspan="3">
      <textarea cols="20" rows="5" id="remark1" name="remark1" ></textarea>
      <span id="characterCount">0 of 100 max characters</span>
</tr>
<tr>
  <th scope="row"><spring:message code='sal.title.text.requestDate' /><span class="must">**</span></th>
  <td>
    <input type="text" title="" placeholder="<spring:message code='service.placeHolder.dtFmt' />" class="j_date w100p" id="effectDt" name="effectDt" />
  </td>
  <th scope="row"><spring:message code='sal.text.requestBy' /></th>
  <td>
    <input type="text" title="" placeholder="<spring:message code='sal.text.requestBy' />" id="userName" name="userName" class="w100p" value="${SESSION_INFO.userName}" readonly />
  </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id=request_btn><spring:message code='sys.btn.save' /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->