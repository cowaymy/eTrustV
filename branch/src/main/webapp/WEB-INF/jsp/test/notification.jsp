<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>

<script type="text/javaScript">

var notificationGridID;

/* =============================================
 * Notification Grid Design -- Start
 * =============================================
 */
var notificationGridPros = {
    usePaging           : true,         //페이징 사용
    pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
    editable            : false,
    fixedColumnCount    : 1,
    showStateColumn     : false,
    displayTreeOpen     : false,
    selectionMode       : "singleRow",  //"multipleCells",
    headerHeight        : 30,
    useGroupingPanel    : false,        //그룹핑 패널 사용
    skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    showRowNumColumn    : true ,       //줄번호 칼럼 렌더러 출력
    showRowCheckColumn : true,
    showRowAllCheckBox : true
};

var notificationColumnLayout = [
    {
        dataField : "ntfId",
        visible : false
    },
    {
        dataField : "ntfFlag",
        visible : false
    },
    {
        dataField : "ntfTypeDesc",
        headerText : "Notification Type",
        width : 300
    },
    {
        dataField : "ntfKey",
        headerText : "Notification Key",
        width : 200
    },
    {
        dataField : "ntfRem",
        headerText : "Notification Remark",
        style : "aui-grid-user-custom-left"
    }
];

/* =============================================
 * Notification Grid Design -- End
 * =============================================
 */

$(document).ready(function() {
    console.log("Notification :: ready :: start");

    notificationGridID = AUIGrid.create("#notification_grid_wrap", notificationColumnLayout, notificationGridPros);

    $("#markBtn").click(fn_markReadUnread);
    console.log("Notification :: ready :: end");
});

function fn_selectNtfList() {
    Common.ajax("GET", "/test/selectNtfList.do", $("#ntfForm").serialize(), function(result) {
        console.log(result);

        AUIGrid.setGridData(notificationGridID, result);

        AUIGrid.setProp(notificationGridID, "rowStyleFunction", function(rowIndex, item) {
            if(item.ntfFlag == 1) {
                return "my-row-style";
            } else {
                return "";
            }
        });

        AUIGrid.update(notificationGridID);
    });
}

function fn_markReadUnread() {
    console.log("fn_markReadUnread :: start");

    var list = AUIGrid.getCheckedRowItems(notificationGridID);
    var data;

    for(var i = 0; i < list.length; i++) {
        var flag;

        if(list[i].item.ntfFlag == "0") {
            flag = "1";
        } else if(list[i].item.ntfFlag == "1") {
            flag = "0";
        }

        data = {
            ntfId : list[i].item.ntfId,
            ntfKey : list[i].item.ntfKey,
            ntfFlag : flag
        };

        Common.ajax("GET", "/test/updateNtf.do", data, function(result) {
            console.log(result);
        });
    }
}

</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2>Notification</h2>
<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
    <li><p class="btn_blue"><a href="#" onClick="fn_selectNtfList()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <%-- </c:if> --%>
    <!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="ntfForm">

<table class="type1"><!-- table start -->
<colgroup>
    <col style="width:175px" />
    <col style="width:*" />
    <col style="width:175px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Notification Date</th>
    <td colspan="3">
        <div class="date_set"><!-- date_set start -->
            <p><input type="text" title="Notification start Date" placeholder="DD/MM/YYYY" class="j_date" id="createDate" name="createDate" /></p>
            <span>To</span>
            <p><input type="text" title="Notification end Date" placeholder="DD/MM/YYYY" class="j_date"  id="endDate" name="endDate"/></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row">Notification Status</th>
    <td>
        <select class="w100p" id="ntfFlag" name="ntfFlag">
            <option value="" selected>Choose One</option>
            <option value="0">Read</option>
            <option value="1">Unread</option>
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
    <li><p class="btn_grid"><a href="#" id="markBtn">Mark Read/Unread</a></p></li>
    <%-- </c:if> --%>
</ul>

<article class="grid_wrap" id="notification_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->