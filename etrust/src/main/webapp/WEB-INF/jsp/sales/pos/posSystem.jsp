<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
Common.getLoadingObj(); 

$(document).ready(function() {
	
    $("#_paymentModeTab").css("display" , "none");
    doGetSalesType('/sales/pos/selectPosSalesTypeJsonList', 'cmbSalesTypeId');
    doGetComboWh("/sales/pos/selectWhList.do", '', '', 'cmbWarehouseId', 'S', '');
    
});

 
  function fn_getUserWarehoseId(url){
	  
	  $.ajax({
	        type : "GET",
	        url : url,
	        dataType : "json",
	        contentType : "application/json;charset=UTF-8",
	        success : function(data) {
	           //get whLocId
	           Common.showLoader();
	           $("#cmbWarehouseId").val(data.whLocId);
	        },
	        error: function(jqXHR, textStatus, errorThrown){
	            alert("No Search Data Warehose Id.");
	        },
	        complete: function(){
	        	Common.removeLoader();
	        }
	    }); 
  }
/* ################ Warehose Combo Box  Start #########################*/
 //def Combo(select Box OptGrouping)
  function doGetComboWh(url, groupCd , selCode, obj , type, callbackFn){
    
    $.ajax({
        type : "GET",
        url : url,
        data : { groupCode : groupCd},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
           var rData = data;
           Common.showLoader();
           fn_otpGrouping(rData, obj)
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        	Common.removeLoader();
        }
    }); 
 } ;

 function fn_otpGrouping(data, obj){
     
     var targetObj = document.getElementById(obj);
     
     for(var i=targetObj.length-1; i>=0; i--) {
            targetObj.remove( i );
     }
     
     obj= '#'+obj;
     
     // grouping
     var count = 0;
     $.each(data, function(index, value){
         
         if(index == 0){
            $("<option />", {value: "", text: 'Choose One'}).appendTo(obj);
         }
         
         if(index > 0 && index != data.length){
             if(data[index].description1 != data[index -1].description1){
                 $(obj).append('</optgroup>');
                 count = 0;
             }
         }
         
         if(data[index].descId == null  && count == 0){
             $(obj).append('<optgroup label="">');
             count++;
         }
         if(data[index].descId == 42 && count == 0){
             $(obj).append('<optgroup label="Cody Branch">');
             count++;
         }
         if(data[index].descId == 1160  && count == 0){
             $(obj).append('<optgroup label="Dealer Branch">');
             count++;
         }
         if(data[index].descId == 43 && count == 0){
             $(obj).append('<optgroup label="Dream Service Center">');
             count++;
         }
         //
         if(data[index].descId == 46 && count == 0){
             $(obj).append('<optgroup label="Head Quaters">');
             count++;
         }
         $('<option />', {value : data[index].whLocId, text:data[index].codeId+'-'+data[index].codeName}).appendTo(obj); // WH_LOC_ID
         
         
         if(index == data.length){
             $(obj).append('</optgroup>');
         }
     });
     //optgroup CSS
     $("optgroup").attr("class" , "optgroup_text");
 }
     /* ################ Warehose Combo Box  End #########################*/



/* ################ Sales Type Combo Box  Start #########################*/
function doGetSalesType(url, obj){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
        	var rData = data;
        	Common.showLoader();
            doGetDefSalesOpt(rData, obj);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        	Common.removeLoader();
        }
    });
} ;

function doGetDefSalesOpt(data, obj){
    var targetObj = document.getElementById(obj);
    var custom = "";

    for(var i=targetObj.length-1; i>=0; i--) {
        targetObj.remove( i );
    }
    
    obj= '#'+obj;
    
    $('<option />', {value : '' , text:'Choose One'}).appendTo(obj).attr("selected", "true");
    
    $.each(data, function(index,value) {
    	//value =  1352, 1353, 1358, 1357, 1361
    	
        if( 322 == data[index].moduleUnitId){
           $('<option />', {value : '1352' , text:'POS - Filter / Spare Part / Miscellaneous'}).appendTo(obj);
        }
        if( 326 == data[index].moduleUnitId){
           $('<option />', {value :  '1353', text:'POS - Item Bank'}).appendTo(obj);
        }
        if( 327 == data[index].moduleUnitId){
            $('<option />', {value :  '1357', text:'POS - Other Income'}).appendTo(obj);
        }
        if( 328 == data[index].moduleUnitId){
            $('<option />', {value :  '1358', text:'POS - Item Bank (HQ)'}).appendTo(obj);
         }
        
    });
    
};
/* ################ Sales Type Combo Box  End #########################*/
 


    function fn_memSearch(){
    	alert("성공!!!");
    }
    
    function fn_clearField(){
    	
    	$("#_paymentModeTab").css("display" , "none");
        $("#_memberCode").attr("disabled" , "disabled");
        $("#_memberSearchBtn").attr("onclick", "");
        $('#_salesDate').val($.datepicker.formatDate('dd-mm-yy', ''));
        $("#_customerName").val('');
        $("#cmbWarehouseId").attr("disabled" , "disabled");
        $("#cmbWarehouseId").val('');
    	$("#cmdPosReasonId").attr("disabled" , "disabled");
    }
    
    function fn_selectSalesTypeRelay(value){
    	
    	//value =  1352, 1353, 1358, 1357, 1361
    	// 1 . Clear
        fn_clearField();
    	
    	// 2. Setting
    	if('' != value && null != value){
    		 
    		/* 선택시 공통사항 */
    		//MemberCode Search Button 활성화
    		$("#_memberCode").attr("disabled" , false);
            $("#_memberSearchBtn").attr("onclick", "javascript : fn_memSearch()");
            //Sale Date 오늘 날짜로 Disable
            $('#_salesDate').val($.datepicker.formatDate('dd-mm-yy', new Date()));
            //Customer Name 가져오기
            $("#_customerName").val('CASH');
            
            /* #########  Active ############### */
            if(value == 1352){       //--------------------POS - Filter                                       
                /* payment Tab Acive Controll */
                $("#_paymentModeTab").css("display" , "");
                /* 1. Purchase Info */
                //세션으로 설정된 Warehose 번호 가져오기
                $("#cmbWarehouseId").attr("disabled" , false);
                //Warehose 활성화 & 선택하기
                fn_getUserWarehoseId("/sales/pos/selectPosUserWarehoseIdJson");
                //POS Reason 활성화
                doGetCombo("/sales/pos/selectPosReasonJsonList", '1363', '', 'cmdPosReasonId', 'S', '');
                $("#cmdPosReasonId").attr("disabled" , false);
                /* 1-1. 우측 */
                //Part Item 활성화 (ComboBox)
                //Quantity 활성화 
                
                /*2. Payment Mode  */
                //Payment Mode 활성화
                //Payment Mode가 cash 일 경우 Bank 불러오기
                //
                //RefDate 활성화
                //
            }
            
            if(value == 1353){ //------------------------POS - Item Bank
                /* payment Tab Acive Controll */
                $("#_paymentModeTab").css("display" , "");
                
            }
            
            if(value == 1358){ //-------------------------POS - Item Bank (HQ)
                /* payment Tab Acive Controll */    
                $("#_paymentModeTab").css("display" , "none");
            
            }
            
            if(value == 1357){   //------------------------POS - Other Income POS
                /* payment Tab Acive Controll */
                $("#_paymentModeTab").css("display" , "none");
            }
    	}
    	
    };
</script>
<div id="wrap"><!-- wrap start -->
<header id="header"><!-- header start -->
<ul class="left_opt">
    <li>Neo(Mega Deal): <span>2394</span></li> 
    <li>Sales(Key In): <span>9304</span></li> 
    <li>Net Qty: <span>310</span></li>
    <li>Outright : <span>138</span></li>
    <li>Installment: <span>4254</span></li>
    <li>Rental: <span>4702</span></li>
    <li>Total: <span>45080</span></li>
</ul>
<ul class="right_opt">
    <li>Login as <span>KRHQ9001-HQ</span></li>
    <li><a href="#" class="logout">Logout</a></li>
    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
    <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
</ul>
</header><!-- header end -->
<hr />
        
<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />
</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu">
    <li class="active">
    <a href="#" class="on">menu 1depth</a>

    <ul>
        <li class="active">
        <a href="#" class="on">menu 2depth</a>

        <ul>
            <li class="active">
            <a href="#" class="on">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
        </ul>

        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
    </ul>

    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
</ul>
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Point Of Sales System</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<aside class="title_line"><!-- title_line start -->
<h3>Please select POS Type</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">POS Type</th>
    <td>
    <select  id="cmbSalesTypeId" name="cmbSalesTypeId" onchange="javascript: fn_selectSalesTypeRelay(this.value)"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
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
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Purchase Info</a></li>
    <li><a href="#" id="_paymentModeTab" >Payment Mode</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:60%;">

<aside class="title_line"><!-- title_line start -->
<h3>Particular Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Member Code</th>
    <td>
    <input type="text" title="" placeholder="" class=""  disabled="disabled" id="_memberCode"/><a href="#" class="search_btn" id="_memberSearchBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search"/></a>
    </td>
</tr>
<tr>
    <th scope="row">Sales Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="_salesDate" disabled="disabled"/>
    </td>
</tr>
<tr>
    <th scope="row">Warehouse</th>
    <td>
    <select class="w100p" id="cmbWarehouseId" disabled="disabled"></select>
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p"  id="_customerName"/>
    </td>
</tr>
<tr>
    <th scope="row">Address 1</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Address 2</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Address 3</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Address 4</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">POS Reason</th>
    <td>
    <select class="w100p" id="cmdPosReasonId" disabled="disabled"></select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>
    <textarea cols="20" rows="5"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</div>

<div style="width:40%;">

<aside class="title_line"><!-- title_line start -->
<h3>Charges Balance</h3>
<ul class="right_btns">
    <li><strong>RM 0.00</strong></li>
</ul>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Total</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">GST (6%)</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Discount</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Purchase Items</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Item Type</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Part Item</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Quantity</th>
    <td>
    <select class="multy_select w100p" multiple="multiple">
        <option value="1">11</option>
        <option value="2">22</option>
        <option value="3">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Purchase</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">CLEAR</a></p></li>
</ul>

</div>

</div><!-- divine_auto end -->

<ul class="right_btns mt40">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h3>Payment Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Total Charges</th>
    <td colspan="5"></td>
</tr>
<tr>
    <th scope="row">Branch Code</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">TR Ref No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">TR Issued Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row">Payment Mode</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Transaction Ref No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Amount</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Credit Card No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">CRC Type</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">CRC Mode</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Approval No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Issue Bank</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Bank Account</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Ref Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
    <th scope="row">Debtor Acc.</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><textarea cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns mt40">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big mt20"><a href="#">Save</a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
        
</section><!-- container end -->
<hr />

</div><!-- wrap end -->
