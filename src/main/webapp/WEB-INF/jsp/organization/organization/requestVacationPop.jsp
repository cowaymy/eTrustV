<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var myGridID4;/* promote */
var myGridID1;/* doc */
var myGridID2;
var myGridID3;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List

//Start AUIGrid
$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid4();
    createAUIGrid1();
    createAUIGrid2();
    createAUIGrid3();

    fn_selectPromote();
    fn_selectDocSubmission();
    fn_selectPaymentHistory();
    fn_selectRenewalHistory();

    // To show Type of Leave selection
    doGetCombo('/common/selectCodeList.do', '378', '','typeofleave', 'S' , '');
    // To show replacementCT of selection
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    console.log(selectedItems);
    var a = selectedItems[0].item.brnchId;
    var b = selectedItems[0].item.memberid;
    var c = selectedItems[0].item.membercode;
    var parm = "?brnch_id="+a+"&mem_id="+b+"&mem_code="+c;
    doGetCombo('/organization/selectReplaceCTList.do'+parm,'' ,'','replacementCT' ,'S','');


    //cody 를 제외하고 Pa Renewal History 와 Cody PA Expired 안보이기 숨긴다
    /* BY KV - Pa Renewal History- only for cody - Cody PA Expired  */
    if($("#memtype").val() != 2){
        $("#hideContent").hide();
        $(".hideContent").hide();
    }

});

function createAUIGrid4() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "codeDesc",
        headerText : "Action",
        editable : false,
        width : 120
    }, {
        dataField : "memorgdescription1",
        headerText : "From",
        editable : false,
        width : 130
    }, {
        dataField : "deptCodeFrom",
        headerText : "Code",
        editable : false,
        width : 130
    }, {
        dataField : "memOrgDesc",
        headerText : "To",
        editable : false,
        width : 130
    }, {
        dataField : "parentDeptCodeTo",
        headerText : "Code",
        editable : false,
        width : 180
    }, {
        dataField : "deptCodeTo",
        headerText : "Superior Team",
        editable : false,
        width : 130
    }, {
        dataField : "rem",
        headerText : "Remark",
        editable : false,
        width : 180

    }, {
        dataField : "userName",
        headerText : "Creator",
        editable : false,
        width : 130

    }, {
        dataField : "crtDt",
        headerText : "Create Date",
        width : 130
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID4 = AUIGrid.create("#grid_wrap4", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

function createAUIGrid1() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "codeName",
        headerText : "Document",
        editable : false,
        width : 700
    }, {
        dataField : "docCopyQty",
        headerText : "Qty",
        editable : false,
        width : 150
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID1 = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

function createAUIGrid2() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "orNo",
        headerText : "Receipt No",
        editable : false,
        width : 120
    }, {
        dataField : "c3",
        headerText : "Payment Date",
        editable : false,
        width : 130
    }, {
        dataField : "billNo",
        headerText : "Bill No.",
        editable : false,
        width : 130
    }, {
        dataField : "codeName",
        headerText : "Pay Type",
        editable : false,
        width : 130
    }, {
        dataField : "c2",
        headerText : "Amount",
        editable : false,
        width : 180
    }, {
        dataField : "c4",
        headerText : "User",
        editable : false,
        width : 130
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID2 = AUIGrid.create("#grid_wrap2", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

function createAUIGrid3() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "c1",
        headerText : "Action",
        editable : false,
        width : 120
    }, {
        dataField : "c2",
        headerText : "Detail",
        editable : false,
        width : 130
    }, {
        dataField : "agExprDt",
        headerText : "Expiry Date",
        editable : false,
        width : 130
    }, {
        dataField : "agCrtDt",
        headerText : "Last Update",
        editable : false,
        width : 130
    }, {
        dataField : "memCode",
        headerText : "updator",
        editable : false,
        width : 180
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID3 = AUIGrid.create("#grid_wrap3", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,

};

function fn_selectDocSubmission(){

    var jsonObj = {
            MemberID : $("#memberid").val(),
            MemberType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectDocSubmission",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID1, result);
        AUIGrid.resize(myGridID1,1000,400);

    });
}

function fn_selectPaymentHistory(){

    var jsonObj = {
            MemberID : $("#memberid").val(),
            MemberType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectPaymentHistory",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID2, result);
        AUIGrid.resize(myGridID2,1000,400);

    });
}

function fn_selectRenewalHistory(){

    var jsonObj = {
            MemberID : $("#memberid").val(),
            MemberType : $("#memtype").val()

    };


    Common.ajax("GET", "/organization/selectRenewalHistory",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID3, result);
        AUIGrid.resize(myGridID3,1000,400);

    });
}

function fn_selectPromote(){
    var jsonObj = {
            MemberID : $("#memberid").val(),
            MemberType : $("#memtype").val()
    };


    Common.ajax("GET", "/organization/selectPromote",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID4, result);
        AUIGrid.resize(myGridID4,1000,400);

    });
}

function fn_tabSize(){
    AUIGrid.resize(myGridID,1000,400);
}

 function fn_vacationRequestSave(){//Request Terminate/Resign
        Common.ajax("POST", "/organization/requestVacationSave.do",  $("#requestVacationForm").serializeJSON(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        Common.alert(result.message,fn_winClose);
    });
}

function fn_winClose(){

    this.close();
}
</script>


<!-- --------------------------------------DESIGN ----------------------------------- -->

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>MEMBERS LIST - VIEW MEMBER</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h4>Member Information</h4>
</aside><!-- title_line end -->
 <input type="hidden" value="<c:out value="${codeValue}"/>" id="codeValue"/>
 <input type="hidden" value="<c:out value="${memberView.memId}"/>" id="memberid"/>
 <input type="hidden" value="<c:out value="${memberView.memType}"/> "  id="memtype"/>
 <input type="hidden" value="<c:out value="${memberView.bank}"/> "  id="bank"/>
 <input type="hidden" value="<c:out value="${memberView.hsptlz}"/> "  id="hsptlz"/>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Spouse Info</a></li>
    <li><a href="#">Organization Info</a></li>
    <li><a href="#" >Document Submission</a></li>
    <li><a href="#"  >Member Payment History</a></li>
    <li><a href="#" >Promote/Demote History</a></li>
    <li id="hideContent" ><a href="#" >Pa Renewal History</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Basic Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <span><c:out value="${memberView.codeName}"/></span>
    </td>
    <th scope="row">Member Status</th>
    <td>
    <span><c:out value="${memberView.name}"/></span>
    </td>
    <th scope="row">Joined Date</th>
    <td>
    <span><c:out value="${memberView.c30}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Member Code</th>
    <td>
    <span><c:out value="${memberView.memCode}"/></span>
    </td>
    <th scope="row">HP Type</th>
    <td>
    <span><c:out value="${memberView.c59}"/></span>
    </td>
    <th scope="row">User Valid Date</th>
    <td>
    <span><c:out value="${memberView.c31}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Member Name</th>
    <td colspan="5">
    <span><c:out value="${memberView.name1}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">NRIC </th>
    <td>
     <span><c:out value="${memberView.nric}"/></span>
    </td>
    <th scope="row">Date of Birth</th>
    <td>
     <span><c:out value="${memberView.c29}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
     <span><c:out value="${memberView.gender}"/></span>
    </td>
</tr>
<tr>
     <th scope="row">Nationality</th>
    <td>
    <span><c:out value="${memberView.c7}"/></span>
    </td>
    <th scope="row">Race</th>
    <td>
    <span><c:out value="${memberView.c40}"/></span>
    </td>
    <th scope="row">Marital Status</th>
    <td>
    <span><c:out value="${memberView.c28}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td colspan="3">
     <span><c:out value="${memberView.c4} - ${memberView.c5} " /></span>
    </td>
    <th scope="row">Email</th>
    <td>
     <span><c:out value="${memberView.email}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Member Group</th>
    <td colspan="3">
     <span><c:out value="${memberView.c41} - ${memberView.c22} - ${memberView.c23} "/></span>
    </td>
    <th scope="row">Transport</th>
    <td>
     <span><c:out value="${memberView.c56}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <span><c:out value="${memberView.telMobile}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${memberView.telOffice}"/></span>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span><c:out value="${memberView.telHuse}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Sponsor's Code</th>
    <td>
    <span><c:out value="${memberView.c51}"/></span>
    </td>
    <th scope="row">Sponsor's Name</th>
    <td>
    <span><c:out value="${memberView.c52}"/></span>
    </td>
    <th scope="row">Sponsor's NRIC</th>
    <td>
    <span><c:out value="${memberView.spouseNric}"/></span>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="3">Address</th>
    <td colspan="3">
    <span><c:out value="${memberView.areaId}   ${memberView.city} "/></span>
     </td>
    <th scope="row">Country</th>
    <td>
    <span><c:out value="${memberView.country}"/></span>
    </td>

</tr>
<tr>
    <td colspan="3">
    <span><c:out value="${memberView.street}"/></span>
     </td>
    <th scope="row">State</th>
    <td>
    <span><c:out value="${memberView.state}"/></span>
    </td>

</tr>
<tr>
    <td colspan="3">
    <span><c:out value="${memberView.addrDtl}"/></span>
   </td>
    <th scope="row">Area<span class="must">*</span></th>
    <td>
    <span><c:out value="${memberView.area}"/></span>
    </td>

</tr>
<tr>
</tr>
<tr>
    <th scope="row">Resign Date</th>
    <td>
     <span></span>
    </td>
    <th scope="row">Terminate Date</th>
    <td>
     <span><c:out value="${memberView.c54}"/></span>
    </td>
    <th scope="row">Postcode</th>
    <td>
    <span><c:out value="${memberView.postcode}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Bank Account No</th>
    <td>
    <span><c:out value="${memberView.bankAccNo}"/></span>
    </td>
    <th scope="row">Issued Bank</th>
    <td colspan="3">
    <select class="w100p" id="bankSelect" disabled="disabled">
        <c:forEach var="list" items="${issuedBank }" varStatus="status">
           <option value="${list.bankId}">${list.c1}</option>
           </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Education Lvl</th>
    <td>
    <span><c:out value="${memberView.c9}"/></span>
    </td>
    <th scope="row">Language</th>
    <td>
    <span><c:out value="${memberView.c11}"/></span>
    </td>
    <th scope="row">TR No</th>
    <td>
    <span><c:out value="${memberView.trNo}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Busninesses Type</th>
    <td>
    <span><c:out value="${memberView.c60}"/></span>
    </td>
    <th scope="row">Hospitalization</th>
    <td>
    <span><input type="checkbox" disabled="disabled" id="hsptlzCheck"/></span>
</tr>
<tr>
    <th scope="row">Applicant Confirm Date</th>
    <td>
    <span><span><c:out value="${ApplicantConfirm.cnfmDt}"/></span></span>
    </td>
    <th scope="row" class="hideContent">Cody PA Expired</th>
    <td class="hideContent">
    <span><span><c:out value="${PAExpired.agExprDt}"/></span></span>
    </td>
</tr>
</tbody>
</table>

<!-- table end -->
<%--
<aside class="title_line"><!-- title_line start -->
<h2>Bank Account Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>

</tbody>
</table><!-- table end -->

 <aside class="title_line"><!-- title_line start -->
<h2>Language Proficiency</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Education Level</th>
    <td>
    <span><c:out value="${memberView.bankAccNo}"/></span>
    </td>
    <th scope="row">Language</th>
    <td>
    <span><c:out value="${memberView.bankAccNo}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>First TR Consign</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">TR No.</th>
    <td>
    <input type="text" title="" placeholder="TR No." class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Agreedment</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Cody PA Expiry<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CANCEL</a></p></li>
</ul>
 --%>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">MCode</th>
    <td>
    <span><c:out value="${memberView.spouseCode}"/></span>
    </td>
    <th scope="row">Spouse Name</th>
    <td>
   <span><c:out value="${memberView.spouseName}"/></span>
    </td>
    <th scope="row">NRIC / Passport No.</th>
    <td>
    <span></span>
    </td>
</tr>
<tr>
    <th scope="row">Occupation</th>
    <td>
    <span><c:out value="${memberView.spouseOcpat}"/></span>
    </td>
    <th scope="row">Date of Birth</th>
    <td>
    <span><c:out value="${memberView.c58}"/></span>
    </td>
    <th scope="row">Contact No.</th>
    <td>
    <span><c:out value="${memberView.spouseTelCntc}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Position</th>
    <td colspan="3">
    <span><c:out value="${memberView.c57}"/></span>
    </td>
    <th scope="row">Member Level</th>
    <td>
    <span><c:out value="${memberView.c44}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td> <span><c:out value="${memberView.c41}"/></span></td>
    <th scope="row">Group Code</th>
    <td> <span><c:out value="${memberView.c42}"/></span></td>
    <th scope="row">Organization Code</th>
    <td> <span><c:out value="${memberView.c43}"/></span></td>
</tr>
<tr>
    <th scope="row">Manager</th>
    <td colspan="5"> <span><c:out value="${memberView.c22} - ${memberView.c23}"/></span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span><c:out value="${memberView.telMobile}"/></span></td>
    <th scope="row">Residence No</th>
    <td><span><c:out value="${memberView.telHuse}"/></span></td>
    <th scope="row">Office No</th>
    <td><span><c:out value="${memberView.telOffice}"/></span></td>
</tr>
<tr>
    <th scope="row">Senior Manager</th>
    <td colspan="5"><span><c:out value="${memberView.c17} - ${memberView.c18}"/></span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span><c:out value="${memberView.c19}"/></span></td>
    <th scope="row">Residence No</th>
    <td><span><c:out value="${memberView.c21}"/></span></td>
    <th scope="row">Office No</th>
    <td><span><c:out value="${memberView.c20}"/></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap1" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap2" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<!-- promote 그리드 -->
<div id="grid_wrap4" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap3" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->
</section><!-- tap_wrap end -->


<!-- =============================================================== -->

<div id="requestVacationPop" style="">
<form  id="requestVacationForm" method="post">
<input type="hidden" value="<c:out value="${memberView.memId}"/>" id="requestMemberId" name="requestMemberId"/>
<%-- <input type="hidden" value="<c:out value="${codeValue}"/>" id="codeValue" name="codeValue"/>
 --%>
 <aside class="title_line"><!-- title_line start -->
<h2>Vacation Request</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type Of Leave</th>
    <td>
    <select class="w100p" id="typeofleave" name="typeofLeave" >
     </select>
    </td>

    <th scope="row">Start Date</th>
    <td>
    <input type="text" title="Create Start Date" placeholder="DD/MM/YYYY" class="j_date" id="dtStart" name="dtStart"/>
    </td>
    <th scope="row">End Date</th>
    <td>
     <input type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date" id="dtEnd" name="dtEnd"/>
    </td>
</tr>
<tr>
    <th scope="row">Replacement CT</th>
    <td colspan="2">
       <select class="w100p" id="replacementCT" name="replacementCT">
       </select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
    <textarea cols="20" rows="5" id="remark" name="remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue2 big "><a href="#" onclick="javascript:fn_vacationRequestSave()">SAVE</a></p></li>
</ul>
</form>
</div>

<!--  ---------------------------------------------------------------------------  -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

