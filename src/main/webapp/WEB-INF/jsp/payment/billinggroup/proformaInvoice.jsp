<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var myGridID;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

    //Application Type 생성
    doGetCombo('/common/selectCodeList.do', '10' , ''   , 'appType' , 'M', 'f_multiCombo');
  
    //key-in Branch 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'keyBranch' , 'M', 'f_multiCombo');
  
    //Branch생성
    doGetComboSepa('/common/selectBranchCodeList.do', '2' , ' - '  ,'' , 'dscBranch' , 'M', 'f_multiCombo');
    
  //product 생성
    doGetComboAndGroup('/common/selectProductList.do', '' , ''   , 'product' , 'S', '');
});

function f_multiCombo() {
    $(function() {
        $('#appType').multipleSelect({
            selectAll : true, // 전체선택 
            width : '80%'
        });
        
        $("#keyBranch").multipleSelect({
            selectAll : true, // 전체선택 
            width : '80%'
        });
        
        $("#dscBranch").multipleSelect({
            selectAll : true, // 전체선택 
            width : '80%'
        });
        
    });
}

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 25
};

var columnLayout=[              
    {dataField:"salesOrdNo", headerText:"Order No"},
    {dataField:"name1", headerText:"Customer Name"},
    {dataField:"invcRefNo", headerText:"Invoice No"},
    {dataField:"invcRefDt", headerText:"Invoice Date"},
    {dataField:"invcSubMemPacAmt", headerText:"Invoice Amount"},
    {dataField:"srvMemQuotNo", headerText:"Installment No"}
];

function fn_getOrderListAjax() {        
	var valid = ValidRequiredField();
	if(!valid){
		 Common.alert("* Please key in either Bill No or Order No.<br />");
	}else{
		Common.ajax("GET", "/payment/selectMembershipList", $("#searchForm").serialize(), function(result) {
	    	AUIGrid.setGridData(myGridID, result);
	    });
	}
}

function ValidRequiredField(){
	var valid = true;
	
	if($("#invoiceNo").val() == "" && $("#orderNo").val() == "")
		valid = false;
	
	return valid;
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Company Rental Invoice</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Company Rental Invoice</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getOrderListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

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
                        <th scope="row">Order No</th>
                        <td>
                            <input id="orderNo" name="orderNo" placeholder="Order Number" type="text" class="w100p" />
                        </td>
                        <th scope="row">Application Type</th>
                        <td>
                            <select id="appType" name="appType" class="multy_select w100p"></select>
                        </td>
                        <th scope="row">Order Date</th>
                        <td>
                           <input type="text" name="orderDt1" placeholder="dd/MM/yyyy" class="j_date" /> To
                           <input type="text" name="orderDt2" placeholder="dd/MM/yyyy" class="j_date" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Order Status</th>
                        <td>
                            <select id="orderStatus" name="orderStatus" class="w100p"></select>
                        </td>
                        <th scope="row">Key-In Branch</th>
                        <td>
                           <select id="keyBranch" name="keyBranch" class="multy_select w100p" multiple="multiple"></select>
                        </td>
                        <th scope="row">DSC Branch</th>
                        <td>
                           <select id="dscBranch" name="dscBranch" class="multy_select w100p" multiple="multiple"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer ID</th>
                        <td>
                            <input id="custId" name="custId" type="text" class="w100p" />
                        </td>
                        <th scope="row">Customer Name</th>
                        <td>
                            <input id="dustName" name="custName" type="text" class="w100p" />
                        </td>
                        <th scope="row">NRIC/Company No</th>
                        <td>
                            <input id="nricNo" name="nricNo" type="text" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                    <th scope="row">Product</th>
                        <td>
                            <select id="product" name="product" class="w100p"></select>
                        </td>
                        <th scope="row">Salesman</th>
                        <td>
                            <input id="salesMan" name="salesMan" type="text" class="w100p" />
                        </td>
                        <th scope="row">Rental Status</th>
                        <td>
                            <select id="product" name="product"class="multy_select w100p" multiple="multiple" >
                                <option value="REG">Regular</option>
                                <option value="INV">Investigate</option>
                                <option value="SUS">Suspend</option>
                                <option value="RET">Return</option>
                                <option value="CAN">Cancel</option>
                                <option value="TER">Terminate</option>
                                <option value="WOF">Write Off</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Reference No</th>
                        <td>
                            <input id="refNo" name="refNo" type="text" class="w100p" />
                        </td>
                        <th scope="row">PO No</th>
                        <td>
                            <input id="poNo" name="poNo" type="text" class="w100p" />
                        </td>
                        <th scope="row">Contact No</th>
                        <td>
                            <input id="contactNo" name="contactNo" type="text" class="w100p" />
                        </td>
                    </tr>
                    </tbody>
              </table>
        </form>
        </section>

 <!-- search_result start -->
<section class="search_result">     

    <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="#">Generate Invoice</a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:showViewPopup()">Send E-Invoice</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section>
</section>

