<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
var cnfmDt, joinDt, agmtStus, memberid;

$(document).ready(function() {
	doGetComboData('/common/selectCodeList.do', { groupCode : '600' , orderValue : 'code_id'}, '', 'listContractType', 'M','fn_multiCombo');

	createAUIGrid();

	AUIGrid.bind(myGridID, "cellDoubleClick", function( event )
    {
        console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log("CellDoubleClick contTrackNo : " + event.item.contTrackNo);
        fn_viewEditContract(event.item.contTrackId);

    });
});

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
	{
	    dataField : "vendorName",
	    headerText : "Vendor Name",
	    width : 180
	},
    {
        dataField : "contractName",
        headerText : "Contract Name",
        width : 180
    },
	{
	    dataField : "contractRefNo",
	    headerText : "Contract Reference No.",
	    width : 180
	},
	{
        dataField : "commDt",
        headerText : "Commencement Date",
        width : 180
    },
	{
        dataField : "expDt",
        headerText : "Expiry Date",
        width : 150
    },
	{
        dataField : "renewalCycle",
        headerText : "Renewal Cycle",
        width : 130
    },
	{
        dataField : "contractOwner",
        headerText : "Contract Owner",
        width : 180
    }, {
        dataField : "contTrackNo",
        headerText : "Automatic Module Generated Running No.",
        width : 300
    }, {
        dataField : "contTrackId",
        visible : false
    }
    ];

    var gridPros = {
             usePaging            : true,
             pageRowCount         : 20,
             editable             : false,
             showStateColumn      : false,
             displayTreeOpen      : false,
             selectionMode        : "singleRow",
             headerHeight         : 30,
             useGroupingPanel     : false,
             skipReadonlyColumns  : true,
             wrapSelectionMove    : true,
             showRowNumColumn     : true
    };

    myGridID = AUIGrid.create("#grid_wrap_contractList", columnLayout, gridPros);
}

function fn_multiCombo(){
    $('#listContractType').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });

}

function fn_searchContractTrackingList() {

    var formData = $("#searchForm").serialize();

    Common.ajax("GET", "/eAccounting/contract/getContractTrackingList.do", formData, function(result) {
        console.log(result);
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_newContract() {
    Common.popupDiv("/eAccounting/contract/contractNewPop.do", {callType:'new'}, null, true, "_contractNewPop");
}

function fn_viewEditContract(contTrackId) {
    Common.popupDiv("/eAccounting/contract/getContractTrackingView.do", {contTrackId:contTrackId,callType:'view'}, null, true, "_contractViewPop");
}

function fn_contractRaw() {
    Common.popupDiv("/eAccounting/contract/contractRawPop.do", null, null, true, '');
}
</script>

<section id="content">
<!-- content start -->
<ul class="path">
    <li><img
        src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
        alt="Home" /></li>
    <li>Contract Expiration Tracking</li>
</ul>

<aside class="title_line">
    <!-- title_line start -->
    <h2>Contract Expiration Tracking</h2>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="javascript:fn_searchContractTrackingList();"><span class="search"></span>Search</a></p></li>
     <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
         <li><p class="btn_blue"><a href="javascript:fn_newContract();">New</a></p></li>
     </c:if>
    </ul>
</aside>

<section class="search_table">
    <!-- search_table start -->
    <form action="#" id="searchForm" method="post">
  <input type="hidden" id="userRole" name="userRole" value="${userRole}" />
        <table class="type1">
            <!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width: 180px" />
                <col style="width: *" />
                <col style="width: 180px" />
                <col style="width: *" />
                <col style="width: 180px" />
                <col style="width: *" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Contract Reference No.</th>
                    <td><input type="text" placeholder="" class="w100p" id="sContractRefNo" name="sContractRefNo" /></td>
                    <th scope="row" id="dtCreatedLbl">Date Created (From)</th>
                    <td>
                        <div class="date_set w100p">
                            <!-- date_set start -->
                            <p>
                                <input type="text" title="Date Created (From)"
                                    placeholder="DD/MM/YYYY" class="j_date" id="_createdFrDt"
                                    name="_createdFrDt" />
                            </p>
                            <span>To</span>
                            <p><input id="_createdEndDt" name="_createdEndDt"
                            type="text" value="" title="Date Created (To)" placeholder="DD/MM/YYYY" class="j_date" /></p>

                        </div> <!-- date_set end -->
                    </td>
                    <th scope="row">Created By</th>
                    <td><input type="text" placeholder="" class="w100p" id="sCreatedBy" name="sCreatedBy" /></td>
                </tr>
                <tr>
                    <th scope="row">Type of Contract</th>
                    <td><!-- <select class="w100p" name="_contractType" id="_contractType"></select> -->
                    <select id="listContractType" name="listContractType[]" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                    <th scope="row">Contract Term</th>
                    <td><input type="text" title="Contract Term(Year)" placeholder="" class="w100p" id="sContractTerm" name=""sContractTerm"" /></td>
                    <th scope="row">Contract Commencement Date</th>
                    <td><div class="date_set w100p">
                            <!-- date_set start -->
                            <p>
                                <input type="text" title="Contract Commencement Date (From)"
                                    placeholder="DD/MM/YYYY" class="j_date" id="_contComFrDt"
                                    name="_contComFrDt" />
                            </p>
                            <span>To</span>
                            <p><input id="_contComeEndDt" name="_contComeEndDt"
                            type="text" value="" title="Contract Commencement Date (To)" placeholder="DD/MM/YYYY" class="j_date" /></p>

                        </div> <!-- date_set end -->
                    </td>
                </tr>
                <tr>
                    <th scope="row">Contract Status</th>
                    <td>
                        <select class="multy_select w100p" multiple="multiple" name="listContractStus">
			                <option value="1">Active</option>
                            <option value="82">Expired</option>
			            </select>
			        </td>
                    <th scope="row">Automatic Module Generated Running No.</th>
                    <td><input type="text" placeholder="" class="w100p" id="sRunNo" name="sRunNo" /></td>
                    <th scope="row" ></th>
                    <td></td>
                </tr>
                <tr>
                    <th scope="row">Contract Owner Department</th>
                    <td><input type="text" placeholder="" class="w100p" id="sOwnerDept" name="sOwnerDept" /></td>
                    <th scope="row">Department's email</th>
                    <td><input type="text" placeholder="" class="w100p" id="sDeptEmal" name="sDeptEmal" /></td>
                    <th scope="row">Department's PIC</th>
                    <td><input type="text" placeholder="" class="w100p" id="sDeptPic" name="sDeptPic" /></td>
                 </tr>
                 <tr>
                    <th scope="row">Vendor's Name</th>
                    <td><input type="text" placeholder="" class="w100p" id="sVendorName" name="sVendorName" /></td>
                    <th scope="row">Vendor's Company Registration No.</th>
                    <td><input type="text" placeholder="" class="w100p" id="sVendorNric" name="sVendorNric" /></td>
                    <th scope="row">Vendor's email</th>
                    <td><input type="text" placeholder="" class="w100p" id="sVendorEmail" name="sVendorEmail" /></td>
                 </tr>
            </tbody>
        </table>
        <!-- table end -->
    </form>
</section>
<!-- search_table end -->

<aside class="link_btns_wrap">
  <!-- link_btns_wrap start -->
  <p class="show_btn">
    <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
  </p>
  <dl class="link_list">
    <dt>Link</dt>
    <dd>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
      <ul class="btns">
        <li><p class="link_btn">
            <a href="#" onclick="javascript:fn_contractRaw()" id="contractRaw">Contract Tracking Raw Data</a>
          </p></li>
      </ul>
      </c:if>
      <ul class="btns">
      </ul>
      <p class="hide_btn">
        <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
      </p>
    </dd>
  </dl>
</aside>
<!-- link_btns_wrap end -->

    <article class="grid_wrap">
        <div id="grid_wrap_contractList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    </article>
</section>
<!-- content end -->
