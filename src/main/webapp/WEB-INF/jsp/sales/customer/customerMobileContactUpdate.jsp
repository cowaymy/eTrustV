<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var mobileContactGridID
    var selectRowIdx;

    // popup 크기
    var option = {
            width : "1200px",   // 창 가로 크기
            height : "500px"    // 창 세로 크기
    };

    var basicAuth = false;

    $(document).ready(function(){

        createAUIGrid();

        $("#status").multipleSelect("checkAll");

        doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','branch', 'S' , '');

        AUIGrid.bind(mobileContactGridID , "cellClick", function( event ){
            selectRowIdx = event.rowIndex;
        });

        AUIGrid.bind(mobileContactGridID, "cellDoubleClick", function(event){
        	if(event.item.statusCode == "P") { //Edit Mode
        		fn_customerMobileContactUpdateDetailView(event.item.statusCode);
        	}
        	else if(event.item.statusCode == "A") { //View Mode
        		fn_customerMobileContactUpdateDetailView(event.item.statusCode);
        	}


        });

      //Search
        $("#_listSearchBtn").click(function() {
            fn_selectPstRequestDOListAjax();
        });

    });

    function fn_customerMobileContactUpdateDetailView(statusCode) {
    	Common.popupDiv("/sales/customer/customerMobileContactUpdateDetailView.do", {ticketNo : AUIGrid.getCellValue(mobileContactGridID, selectRowIdx, "ticketNo"), statusCode : statusCode}, null, true, '_mobileUpdateDiv');
    	fn_selectPstRequestDOListAjax();
    }

    function fn_tokenTest() {
        Common.popupDiv("/sales/customer/tokenCustCrcTest.do", $("#searchForm").serializeJSON(), null, true, '_cardDiv');
    }

    function createAUIGrid() {

        var columnLayout = [ {
                dataField : "ticketNo",
                headerText : 'Ticket No',
                editable : false
            }, {
                dataField : "orderNo",
                headerText : 'Order No',
                editable : false
            }, {
                dataField : "custName",
                headerText : 'Customer Name',
                width : 500,
                editable : false
            }, {
                dataField : "reqstDt",
                headerText : 'Request Date',
                dataType : "date",
                formatString : "dd/mm/yyyy",
                editable : false
            }, {
                dataField : "reqstDt",
                headerText : 'Request Time',
                dataType : "date",
                formatString : "HH:MM:ss",
                editable : false
            },{
                dataField : "status",
                headerText : 'Status',
                editable : false
            },{
                dataField : "postingBrch",
                headerText : 'Posting Branch',
                editable : false
            },{
                dataField : "crtUserId",
                headerText : 'Creator',
                editable : false
            },{
                dataField : "updUserId",
                headerText : "Last Update",
                editable : false
           }];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
            headerHeight : 30,
            useGroupingPanel : false,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true
        };

        mobileContactGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    function fn_selectPstRequestDOListAjax() {
        Common.ajax("GET", "/sales/customer/selectMobileUpdateJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(mobileContactGridID, result);
        }
        );
    }

    function f_multiCombo(){
        $(function() {
            $('#status').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
        });
    }

</script>

<form id="popForm" method="post">
    <input type="hidden" name="custId"  id="_custId"/>  <!-- Cust Id  -->
    <input type="hidden" name="custAddId"   id="_custAddId"/><!-- Address Id  -->
    <input type="hidden" name="custCntcId"   id="_custCntcId"> <!--Contact Id  -->
    <input type="hidden" name="custAccId"   id="_custAccId">
    <input type="hidden" name="_custNric"   id="_custNric">
</form>
<!-- edit Pop Form  -->
<form id="editForm" method="post">
    <input type="hidden" name="editCustId" id="_editCustId"/>
    <input type="hidden" name="editCustAddId" id="_editCustAddId"/>
    <input type="hidden" name="editCustCntcId" id="_editCustCntcId">
    <input type="hidden" name="editCustBankId" id="_editCustBankId">
    <input type="hidden" name="editCustCardId" id="_editCustCardId">
    <input type="hidden" name="editCustNric" id="_editCustNric">
</form>
<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/CustVALetter.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="123123" /> --><!-- Download Name -->

    <!-- params -->
    <input type="hidden" id="_repCustId" name="@CustID" />
</form>

<form id="dataForm3">
    <input type="hidden" id="fileName" name="reportFileName" value="/sales/CustVALetter_V2.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="downFileName_V2" name="reportDownFileName" value="" /> <!-- Download Name -->

    <!-- params -->
    <input type="hidden" id="_repCustId2" name="@CustID" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Mobile Contact Info Update</h2>

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_listSearchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" action="#" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Request Date</th>
        <td>
        <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqStartDt" name="reqStartDt"/></p>
                <span>to</span>
                <p><input type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" id="reqEndDt" name="reqEndDt"/></p>
        </div><!-- date_set end -->
        </td>
        <th scope="row">Posting Branch</th>
        <td>
                <select id="branch" name="branch" class="w100p"></select>
        </td>
        <th scope="row">Customer Name</th>
        <td>
          <input type="text" title="Customer Name" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Order No</th>
        <td>
          <input type="text" title="Order No" id="ordNo" name="ordNo" placeholder="Order No" class="w100p" />
        </td>
        <th scope="row">Status</th>
        <td>
          <select class="multy_select w100p" multiple="multiple" id="status" name="status">
                <option value="P">Active</option>
                <option value="A">Approved</option>
                <option value="J">Rejected</option>
          </select>
        </td>
        <th scope="row">Dept Code</th>
        <td>
        <input type="text" title="Dept Code" id="deptCode" name="deptCode" placeholder='Dept Code' class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Org Code</th>
        <td>
          <input type="text" title="Org Code" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" />
        </td>
        <th scope="row">Grp Code</th>
        <td>
          <input type="text" title="Grp Code" id="grpCode" name="grpCode" placeholder="Grp Code" class="w100p" />
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->
