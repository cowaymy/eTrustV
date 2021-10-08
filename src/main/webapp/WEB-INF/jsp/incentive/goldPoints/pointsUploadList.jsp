<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    //AUIGrid 생성 후 반환 ID
    var myGridID;

    $(document).ready(function(){

        createAUIGrid();

    });

    function createAUIGrid() {

        var columnLayout = [ {
                dataField : "gpBatchId",
                headerText : "<spring:message code='sal.title.text.batchNo' />",
                width : 130,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stusCode",
                headerText : "<spring:message code='sal.title.text.batchStus' />",
                width : 130,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "crtDt",
                headerText : "<spring:message code='sal.text.createDate' />",
                width : 130,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "crtUserName",
                headerText : "<spring:message code='sal.text.creator' />",
                width : 140,
                editable : false,
                style: 'left_style'
            }];

        var gridPros = {

            usePaging : true,
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            useGroupingPanel : false,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : false,
            showRowCheckColumn : true,
            showRowAllCheckBox : true
        };

        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function fn_searchPointsUploadList(){
        Common.ajax("GET", "/incentive/goldPoints/selectPointsUploadList", $("#gpUploadSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_creditPoints() {
        Common.popupDiv("/incentive/goldPoints/uploadPointsPop.do", null, null, true, "uploadPointsPop");
    }

    function fn_confirmPointsPop() {

        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

        if (selectedItems.length <= 0) {
          // NO DATA SELECTED.
          Common.alert("<spring:message code='service.msg.NoRcd'/> ");
          return;
        }

        if (selectedItems.length > 1) {
          // ONLY SELECT ONE ROW PLEASE
          Common.alert("<b><spring:message code='service.msg.onlyPlz'/><b>");
          return;
        }

        var gpBatchId = selectedItems[0].item.gpBatchId;
        var stusCode = selectedItems[0].item.stusCode;

        Common.popupDiv("/incentive/goldPoints/confirmPointsPop.do?gpBatchId="
                    + gpBatchId, "", null, "true", "confirmPointsPop");
    }

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>MISC</li>
    <li>Incentive Rewards</li>
    <li>Gold Points Redemption</li>
</ul>

<aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>Points Upload</h2>
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="#" onClick="fn_searchPointsUploadList()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
        </c:if>
    </ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="gpUploadSearchForm" name="gpUploadSearchForm" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
        <tbody>
            <tr>
                <th scope="row">Batch No</th>
                <td >
                <input type="text" title="" id="gpBatchId" name="gpBatchId" placeholder="Upload Batch Number" class="w100p" />
                </td>
                <th scope="row"><spring:message code="sal.text.createDate" /></th>
                <td>
                <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" id="gpUploadCreateStDate" name="gpUploadCreateStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                <span>To</span>
                <p><input type="text" id="gpUploadCreateEnDate" name="gpUploadCreateEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                </div><!-- date_set end -->
                </td>
                 <th scope="row"><spring:message code="sal.text.creator" /></th>
                <td>
                <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Upload (Username)" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
                <td>
                <select id="cmbBatchStatus" name="cmbBatchStatus" class="multy_select w100p" multiple="multiple">
                    <option value="1" ><spring:message code="sal.combo.text.active" /></option>
                    <option value="4" ><spring:message code="sal.combo.text.compl" /></option>
                    <option value="8"><spring:message code="sal.combo.text.inactive" /></option>
                </select>
                </td>
                <th scope="row"></th>
                <td></td>
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
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_creditPoints()">Credit Points</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_confirmPointsPop()">Confirm Points</a></p></li>
        </c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->