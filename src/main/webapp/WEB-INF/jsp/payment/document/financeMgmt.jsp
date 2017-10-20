<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var receiveListGrid;
var creditCardGrid;

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 5,
        height:200
};

var receiveColumnLayout=[
                 {
                	colSpan : 2,
			        dataField : "undefined",
			        headerText : " ",
			        width: 70,
			        renderer : {
			            type : "ButtonRenderer",
			            labelText : ">",
			            onclick : function(rowIndex, columnIndex, value, item) {
			                alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " 상세보기 클릭");
			            }
			        }
			       },
			       {
			    	    colSpan : -1,
	                    dataField : "undefined",
	                    headerText : " ",
	                    width: 70,
	                    renderer : {
	                        type : "ButtonRenderer",
	                        labelText : "...",
	                        onclick : function(rowIndex, columnIndex, value, item) {
	                            alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " 상세보기 클릭");
	                        }
	                    }
	                   },
                  {dataField:"name", headerText:"Status"},
                  {dataField:"batchNo", headerText:" "},
                  {dataField:"payDt", headerText:"pay Date"},
                  {dataField:"isOnline", headerText:"is Online",
			        renderer:{
			            type : "CheckBoxEditRenderer",
			            showLabel : false,
			            editable : false,
			            checkValue : "1",
			            unCheckValue : "0"
			        }   
                  },
                  {dataField:"oriCcNo", headerText:"Crc No"},
                  {dataField:"amt", headerText:"Amount"},
                  {dataField:"mid", headerText:"MID"},
                  {dataField:"codeName1", headerText:"Crc Type"},
                  {dataField:"ccHolderName", headerText:"Crc Holder"},
                  {dataField:"ccExpr", headerText:"Crc Expiry"},
                  {dataField:"appvNo", headerText:"Appv No",dataType:"date",formatString:"dd-mm-yyyy"},
                  {dataField:"code2", headerText:"Bank"},
                  {dataField:"accCode", headerText:"Settlement Acc"},
                  {dataField:"refDt", headerText:"Ref Date"},
                  {dataField:"", headerText:"Ref No"}
           ];
 var creditCardColumnLayout=[
                            {
                                dataField : "undefined",
                                headerText : " ",
                                width: 70,
                                renderer : {
                                    type : "ButtonRenderer",
                                    labelText : ">",
                                    onclick : function(rowIndex, columnIndex, value, item) {
                                        alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " 상세보기 클릭");
                                    }
                                }
                               },
                               {dataField:"payDt", headerText:"Pay Date"},
                               {dataField:"isOnline", headerText:"is Online",
                                   renderer:{
                                       type : "CheckBoxEditRenderer",
                                       showLabel : false,
                                       editable : false,
                                       checkValue : "1",
                                       unCheckValue : "0"
                                   }   
                                 },
                               {dataField:"oriCcNo", headerText:"Crc No"},
                               {dataField:"amt", headerText:"Amount"},
                               {dataField:"mid", headerText:"MID"},
                               {dataField:"codeName", headerText:"Crc Type"},
                               {dataField:"ccHolderName", headerText:"Crc Holder",dataType:"date",formatString:"dd-mm-yyyy"},
                               {dataField:"ccExpr", headerText:"Crc Expiry"},
                               {dataField:"appvNo", headerText:"Appv No"},
                               {dataField:"code2", headerText:"Bank"},
                               {dataField:"accCode", headerText:"Settlement Acc"},
                               {dataField:"refDt", headerText:"Ref Date"},
                               {dataField:"refNo", headerText:"Ref No"}
                            ];
           
$(document).ready(function(){
	
	receiveListGrid =  GridCommon.createAUIGrid("#grid_wrap_receive_list", receiveColumnLayout, null, gridPros);
	creditCardGrid = GridCommon.createAUIGrid("#grid_wrap_credit_card_list", creditCardColumnLayout, null, gridPros);
	//Issue Bank 조회
	doGetCombo('/sales/customer/selectAccBank.do', '', '', 'rIssueBank', 'S', '')//selCodeAccBankId(Issue Bank)
    doGetCombo('/sales/customer/selectAccBank.do', '', '', 'cIssueBank', 'S', '')//selCodeAccBankId(Issue Bank)
    
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'' , 'rBranch' , 'S', ''); //key-in Branch 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - '  ,'137' , 'cBranch' , 'S', ''); //key-in Branch 생성
    
    doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'rSetAccount' , 'S', '');
    doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'cSetAccount' , 'S', '');
	 
});


//크리스탈 레포트
function fn_generateStatement(){
	
	if(FormUtil.checkReqValue($("#orderNo")) &&  FormUtil.checkReqValue($("#billNo"))){
        Common.alert('* Please key in either RET No or Order No. <br>');
        return;
    }
	
	Common.ajax("POST", "/payment/selectPenaltyBillDate.do", $("#searchForm").serializeJSON(), function(result) {
		
    });
}

function fn_rSearch(){
	$('#rPaymode').removeAttr('disabled');
    Common.ajax("GET", "/payment/selectReceiveList.do", $("#rSearchForm").serializeJSON(), function(result) {
    	AUIGrid.setGridData(receiveListGrid, result);
    });
    $('#rPaymode').attr('disabled', 'true');
    
}

function fn_cSearch(){
	$('#cPaymode').removeAttr('disabled');
    Common.ajax("GET", "/payment/selectCreditCardList.do", $("#cSearchForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(creditCardGrid, result);
    });
    $('#cPaymode').attr('disabled', 'true');
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Finance Management</h2>
</aside><!-- title_line end -->


<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on on"><a href="#">Receive List Management</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="javascript:fn_rSearch()"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
    </ul>
    <form id="rSearchForm" name="rSearchForm">
    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Paymode</th>
        <td>
        <select id="rPaymode" name="rPaymode" class="w100p disabled" disabled="disabled">
            <option selected value="107">Credit Card</option>
        </select>
        </td>
        <th scope="row">Is Online</th>
        <td>
        <select id="rOnline" name="rOnline" class="multy_select w100p" multiple="multiple">
            <option value="1">Online</option>
            <option value="0">Offline</option>
        </select>
        </td>
        <th scope="row">Merchant ID</th>
        <td>
        <input type="text" title="" placeholder="Merchant ID" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Reference Date</th>
        <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
        </td>
        <th scope="row">Credit Card Number</th>
        <td>
        <input type="text" title="" placeholder="Credit Card Number" class="w100p" />
        </td>
        <th scope="row">Card Holder Name</th>
        <td>
        <input type="text" title="" placeholder="Card Holder Name" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Approval Number</th>
        <td>
        <input type="text" title="" placeholder="Approval Number" class="w100p" />
        </td>
        <th scope="row">Credit Card Type</th>
        <td>
        <select id="rCreditCardType" name="rCreditCardType" class="w100p">
            <option value="111">MASTER</option>
            <option value="112">VISA</option>
        </select>
        </td>
        <th scope="row">Issue Bank</th>
        <td>
        <select id="rIssueBank" name="rIssueBank" class="w100p">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Payment Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        <select id="rBranch" name="rBranch" class="w100p">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Batch No</th>
        <td>
        <input type="text" title="" placeholder="Batch No" class="w100p" />
        </td>
        <th scope="row">Batch Status</th>
        <td>
        <select id="rBatchNo" name="rBatchNo" class="multy_select w100p" multiple="multiple">
            <option value="1">Active</option>
            <option value="36">Closed</option>
        </select>
        </td>
        <th scope="row">Item Status</th>
        <td>
        <select id="rItemStatus" name="rItemStatus" class="multy_select w100p" multiple="multiple">
            <option value="33">New</option>
            <option value="79">Resend</option>
            <option value="53">Review</option>
            <option value="4">Complete</option>
            <option value="50">Incomplete</option>
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Batch Create Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Batch Creator</th>
        <td>
        <input type="text" title="" placeholder="Batch Creator" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Settlement Account</th>
        <td colspan="5">
        <select id="rSetAccount" name="rSetAccount" class="w100p">
        </select>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
</form>
    </dd>
    <dt class="click_add_on"><a href="#">Pending List Management</a></dt>
    <dd>
    <ul class="right_btns">
        <li><p class="btn_blue"><a href="javascript:fn_cSearch();"><span class="search"></span>Search</a></p></li>
        <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
    </ul>
<!-- ####################################################################################3 -->
    <form id="cSearchForm" name="cSearchForm">
    <table class="type1 mt10"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Paymode</th>
        <td>
        <select id="cPaymode" name="cPaymode" class="w100p disabled"  disabled="disabled">
            <option value="107">Credit Card</option>
        </select>
        </td>
        <th scope="row">Is Online</th>
        <td>
        <select class="multy_select w100p" multiple="multiple">
            <option value="1">Online</option>
            <option value="0">Offline</option>
        </select>
        </td>
        <th scope="row">Merchant ID</th>
        <td>
        <input type="text" title="" placeholder="Merchant ID" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Reference Date</th>
        <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
        </td>
        <th scope="row">Credit Card Number</th>
        <td>
        <input type="text" title="" placeholder="Credit Card Number" class="w100p" />
        </td>
        <th scope="row">Card Holder Name</th>
        <td>
        <input type="text" title="" placeholder="Card Holder Name" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row">Approval Number</th>
        <td>
        <input type="text" title="" placeholder="Approval Number" class="w100p" />
        </td>
        <th scope="row">Credit Card Type</th>
        <td>
        <select class="w100p">
            <option value="111">MASTER</option>
            <option value="112">VISA</option>
        </select>
        </td>
        <th scope="row">Issue Bank</th>
        <td>
        <select id="cIssueBank" name="cIssueBank" class="w100p">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Payment Date</th>
        <td colspan="3">

        <div class="date_set"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

        </td>
        <th scope="row">Key-In Branch</th>
        <td>
        <select id="cBranch" name="cBranch" class="w100p">
        </select>
        </td>
    </tr>
    <tr>
        <th scope="row">Settlement Account</th>
        <td colspan="5">
        <select id="cSetAccount" name="cSetAccount">
        </select>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->
</form>
    </dd>
</dl>
</article><!-- acodi_wrap end -->

<div class="divine_auto mt30"><!-- divine_auto start -->

<div style="width:55%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">WReceive List - Credit Card (Offline) </h3>
</aside><!-- title_line end -->

<article id="grid_wrap_receive_list" class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<div class="side_btns"><!-- side_btns start -->
<ul class="left_btns">
    <li>New</li>
    <li class="yellow_text">Resend </li>
    <li class="pink_text">Review </li>
    <li class="green_text">Complete </li>
    <li class="orange_text">Incomplete</li>
</ul>
<ul class="right_btns">
    <li>Ctrl + Click : for multiple selection</li>
</ul>
</div><!-- side_btns end -->

</div><!-- border_box end -->

</div>

<div style="width:45%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Credit Card (Online/Offline)</h3>
</aside><!-- title_line end -->

<article id="grid_wrap_credit_card_list" class="grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="right_btns">
    <li>Pending : Waiting for admin management</li>
</ul>

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

<aside class="title_line mt30"><!-- title_line start -->
<h3 class="pt0">Document Control Log</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- content end -->


