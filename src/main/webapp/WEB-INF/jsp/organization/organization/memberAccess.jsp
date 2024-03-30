<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/moment.min.js"></script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
//파일 저장 캐시
var myFileCaches = {};
var excelGridID;
// 최근 그리드 파일 선택 행 아이템 보관 변수
var recentGridItem = null;
// GRID VIEW DISPLAY
var memberAccessLayout = [ {
    dataField : "membercode",
    headerText : "Member Code",
}, {
    dataField : "name",
    headerText : "Name",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "nric",
    headerText : "NRIC",
}, {
    dataField : "orgCode",
    headerText : "Org Code",
}, {
    dataField : "grpCode",
    headerText : "Group Code",
}, {
    dataField : "deptCode",
    headerText : "Dept Code",
}, {
    dataField : "positionName",
    headerText : "Position Name",
}
];

function createAUIGridExcel() {

    var excelColumnLayout = [ {
        dataField : "memCode",
        headerText : "Member Code",
        editable : true,
        width : 130
    }, {
        dataField : "name",
        headerText : "Name",
        editable : true,
        width : 130
    }, {
        dataField : "nric",
        headerText : "Nric",
        editable : true,
        width : 130
    }, {
        dataField : "orgCode",
        headerText : "Organization Code",
        editable : true,
        width : 130
    },  {
        dataField : "grpCode",
        headerText : "Group Code",
        editable : true,
        width : 130
    }, {
        dataField : "deptCode",
        headerText : "Department Code",
        editable : true,
        width : 130
    },
    ]

    var excelGridPros = {
            enterKeyColumnBase : true,
            useContextMenu : true,
            enableFilter : true,
            showStateColumn : true,
            displayTreeOpen : true,
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
            groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
            exportURL : "/common/exportGrid.do"
    };

    excelGridID = GridCommon.createAUIGrid("staffClaim_grid_wrap", excelColumnLayout, "", excelGridPros);
}

//그리드 속성 설정
var staffClaimGridPros = {
    // 페이징 사용
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
 // 헤더 높이 지정
    headerHeight : 40,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var memberID = "${SESSION_INFO.memId}";
var staffClaimGridID;

$(document).ready(function () {
    staffClaimGridID = AUIGrid.create("#staffClaim_grid_wrap", memberAccessLayout, staffClaimGridPros);

    $("#_approvalBtn").click(function() {
        Common.popupDiv("/organization/memberAccessApproveView.do", null, null, true);
    });


    /* createAUIGridExcel(); */

    AUIGrid.bind(staffClaimGridID, "cellDoubleClick", function( event ) {


        var memberCode = event.item.membercode;
        console.log("CellDoubleClick memberID : " + memberID);
        console.log("CellDoubleClick memberCode : " + memberCode);

        // TODO detail popup open
        var data = {
                memberCode : memberCode,
                callType : "view"
        };
        Common.popupDiv("/organization/selectMemberAccessDetailPop.do", data, null, true, "membertype");
        });

        //fn_selectStaffClaimList();


});

function fn_memberListSearch() {
    Common.ajax("GET", "/organization/memberAccessListSearch", $("#form_staffClaim").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(staffClaimGridID, result);
    });
}

function fn_NewClaimPop() {
    Common.popupDiv("/newClaim/newPop.do", {callType:"new", claimType:"J2"}, null, true, "newClaimPop");
}



function fn_insertStaffClaimExp(st) {
    // row의 수가 0개 이상일때만 insert
    var gridDataList = AUIGrid.getOrgGridData(newGridID);
    if(gridDataList.length > 0){
        var data = {
                gridDataList : gridDataList
                ,allTotAmt : Number($("#allTotAmt_text").text().replace(/,/gi, ""))
        }
        console.log(data);
        Common.ajax("POST", "/eAccounting/staffClaim/insertStaffClaimExp.do", data, function(result) {
            console.log(result);
            clmNo = result.data.clmNo;
            fn_selectStaffClaimItemList();

            if(st == "new"){
                Common.alert('<spring:message code="newWebInvoice.tempSave.msg" />');
                $("#newStaffClaimPop").remove();
            }
            fn_selectStaffClaimList();
        });
    } else {
        Common.alert('<spring:message code="pettyCashExp.noData.msg" />');
    }
}

function fn_viewStaffClaimPop(clmNo) {
    var data = {
            clmNo : clmNo,
            callType : "view"
    };
    Common.popupDiv("/eAccounting/staffClaim/viewStaffClaimPop.do", data, null, true, "viewStaffClaimPop");
}



function fn_approveLinePop(memAccId, clmMonth, costCentre) {
    // check request - Request once per user per month
    Common.ajax("POST", "/eAccounting/staffClaim/checkOnceAMonth.do?_cacheId=" + Math.random(), {clmType:"J4", memAccId:memAccId, clmMonth:clmMonth}, function(result) {
        console.log(result);
        if(result.data > 0) {
            Common.alert(result.message);
        } else {
            // tempSave를 하지 않고 바로 submit인 경우
            if(FormUtil.isEmpty(clmNo)) {
                fn_insertStaffClaimExp("");
            } else {
                // 바로 submit 후에 appvLinePop을 닫고 재수정 대비
                fn_updateStaffClaimExp("");
            }

            Common.popupDiv("/eAccounting/staffClaim/approveLinePop.do", {clmType:"J4", memAccId:memAccId, clmMonth:clmMonth}, null, true, "approveLineSearchPop");
        }
    });
}


function fn_webInvoiceRequestPop(appvPrcssNo, clmType) {
    var data = {
            clmType : clmType
            ,appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/webInvoiceRqstViewPop.do", data, null, true, "webInvoiceRqstViewPop");
}

function fn_getTotCarMilag(rowIndex) {
    var totCarMilag = 0;
    // 필터링이 된 경우 필터링 된 상태의 값만 원한다면 false 지정
    console.log(amtArr);
    for(var i = 0; i < amtArr.length; i++) {
        totCarMilag += amtArr[i];
    }
    // 0번째 행의 name 칼럼의 값 얻기
    var value = AUIGrid.getCellValue(mileageGridID, rowIndex, "carMilag");
    console.log(totCarMilag);
    console.log(value);
    totCarMilag -= value;
    console.log("totCarMilag : " + totCarMilag);
    return totCarMilag;
}


function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("staffClaim_grid_wrap", "xlsx", "MemberAccessList");
}

function fn_searchPosition(selectedData){
    $("#position option").remove();
      if(selectedData == "2" || selectedData =="3" || selectedData =="1" || selectedData =="7" || selectedData =="5758" || selectedData =="6672"){
           $("#position").attr("disabled",false);   /*position button enable*/
           Common.ajax("GET",
                    "/organization/searchPosition.do",
                    "memberType="+selectedData,
                    function(result) {
                        $("#position").append("<option value=''>Select Position</option> " );
                        for(var idx=0; idx < result.length ; idx++){
                            $("#position").append("<option value='" +result[idx].positionLevel+ "'> "+result[idx].positionName+ "</option>");
                        }
                    }
           );
       }else{
           /*position button disable*/
           $("#position").attr("disabled",true);
           /* If you want to set position default value remove under comment.*/
           $("#position").append("<option value=''>Select Account</option> " );

       }
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Member Access</h2>
<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
    <li><p class="btn_blue"><a href="javascript:fn_memberListSearch();"><span class="search"></span>Search</a></p></li>
    <%-- </c:if> --%>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_staffClaim">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="pageAuthFuncUserDefine1" name="pageAuthFuncUserDefine1" value="${PAGE_AUTH.funcUserDefine1}">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>

    <!-- By KV start - when memtypecom selected item then go to fn_searchPosition function-->
    <select class="w100p" id="memTypeCom" name="memTypeCom" onchange="fn_searchPosition(this.value)">
     <!-- By KV end - when memtypecom selected item then go to fn_searchPosition function-->

        <option value="" selected>Select Account</option>
         <c:forEach var="list" items="${memberType }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Code</th>
    <td>
    <input type="text" title="Code" placeholder="" class="w100p" id="code" name="code" />
    </td>
    <th scope="row">Name</th>
    <td>
    <input type="text" title="Name" placeholder="" class="w100p" id="name" name="name" />
    </td>
    <th scope="row">IC Number</th>
    <td>
    <input type="text" title="IC Number" placeholder="" class="w100p" id="icNum" name="icNum" />
    </td>
</tr>
<tr>
    <th scope="row">Contact No</th>
    <td>
    <input type="text" title="Contact No" placeholder="" class="w100p" id="contact" name="contact"/>
    </td>
    <th scope="row">Position</th>
    <td>
    <select class="w100p" id="position" name="position">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${position}" varStatus="status">
            <option value="${list.positionLevel}">${list.positionName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Sponsor's Code</th>
    <td>
     <input type="text" title="Sponsor's Code" placeholder="" class="w100p" id=sponsor name="sponsor"/>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Org Code</th>
    <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
    <th scope="row">Grp Code</th>
    <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
    <th scope="row">Dept Code</th>
    <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">
            <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"> --%>
            <li><p class="link_btn"><a href="#" id="_approvalBtn">Approval</a></p></li>
            <%-- </c:if> --%>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid"><a href="javascript:fn_excelDown();">GENERATE</a></p></li>
    </c:if>
    <!-- <li><p class="btn_grid"><a href="#" id="registration_btn">New Request</a></p></li> -->
</ul>

<article class="grid_wrap" id="staffClaim_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->