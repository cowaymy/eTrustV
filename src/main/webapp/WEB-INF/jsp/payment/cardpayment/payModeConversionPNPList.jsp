<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    var myGridID;

    $(document).ready(function(){
        createAUIGrid();

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            Common.popupDiv("/sales/order/paymodeConversionDetailPNPPop.do", {payCnvrId : event.item.payCnvrId}, null, true, 'detailPop');
        });
    });

    function createAUIGrid() {
        var columnLayout = [ {
                dataField : "payCnvrNo",
                headerText : "<spring:message code='sal.title.text.batchNo' />",
                width : "15%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrStusFrom",
                headerText : "<spring:message code='sal.title.text.statusFrom' />",
                width : "12%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrStusTo",
                headerText : "<spring:message code='sal.title.text.statusTo' />",
                width : "12%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrTotalItm",
                headerText : "Total Item",
                width : "12%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrCrtDt",
                headerText : "<spring:message code='sal.text.createDate' />",
                width : "15%",
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "username1",
                headerText : "Creator",
                width : "10%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrId",
                visible : false
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

            groupingMessage : "Here groupping"
        };

        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function fn_searchListAjax(){
        Common.ajax("GET", "/sales/order/paymodeConversionList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_newConvert(){
        Common.popupDiv("/sales/order/paymodeConversionPNP.do", null, null, true, 'savePop');
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
                this.selectedIndex = -1;
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
<h2>PNP RPS Paymode Conversion List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_newConvert()"><spring:message code="sal.btn.new" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside>


<section class="search_table">
<form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="isPnp" name="isPnp" value="1" />
    <table class="type1">
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
                <td colspan="3">
                <input type="text" title="" id="batchNo" name="batchNo" placeholder="Batch Number" class="w100p" />
                </td>
                <th scope="row"><spring:message code="sal.text.createDate" /></th>
                <td>
                <div class="date_set w100p">
                <p><input type="text" id="createStDate" name="createStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                <span>To</span>
                <p><input type="text" id="createEnDate" name="createEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                </div>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.statusFrom" /></th>
                <td>
                <select class="multy_select w100p" id="cmbStatusFr" name="cmbStatusFr" multiple="multiple">
                    <option value="PNP">PNP PRS</option>
                    <option value="CRC">CRC</option>
                    <option value="DD">DD</option>
                    <option value="REG"><spring:message code="sal.combo.text.regular" /></option>
                </select>
                </td>
                <th scope="row"><spring:message code="sal.title.text.statusTo" /></th>
                <td>
                <select class="multy_select w100p" id="cmbStatusTo" name="cmbStatusTo" multiple="multiple">
                    <option value="PNP">PNP PRS</option>
                    <option value="REG"><spring:message code="sal.combo.text.regular" /></option>
                </select>
                </td>
                <th scope="row"><spring:message code="sal.text.creator" /></th>
                <td>
                <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Username" class="w100p" />
                </td>
            </tr>
        </tbody>
    </table>

</form>
</section>

    <section class="search_result">
        <article class="grid_wrap">
            <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
        </article>
    </section>

</section>