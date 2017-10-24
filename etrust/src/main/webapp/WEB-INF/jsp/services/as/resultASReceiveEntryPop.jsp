<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">


var asHistoryGrid; 
var bsHistoryGrid; 
//var roderInfo  ='${as_ord_basicInfo}';

console.log("in load....");
//console.log(roderInfo);

function fn_ASSave(){
       Common.ajax("GET", "/services/as/addASNo.do", {}, function(result) {
            console.log("성공.");
            console.log("data : " + result);
        });
}






$(document).ready(function(){
    fn_keyEvent();
    

    AUIGrid.resize(asHistoryGrid,1000,300); 
    AUIGrid.resize(bsHistoryGrid,1000,300); 
    
    createASHistoryGrid();
    createBSHistoryGrid();
    
    fn_getASHistoryInfo();
    fn_getBSHistoryInfo();
    
});


function fn_setComboBox(){
    doGetCombo('/common/selectCodeList.do', '23', '','Requestor', 'S' , 'fn_multiCombo'); 
}




function fn_gird_resize(){

    AUIGrid.resize(asHistoryGrid,900,300); 
    AUIGrid.resize(bsHistoryGrid,900,300); 
}




function  fn_loadASOrderInfo(){
	//this.clearASPanel();
	
	//getASHistoryInfo
	//getBSHistoryInfo
	
    //this.LoadASPanel_AS(OrderID);
    //this.LoadASPanel_BS(OrderID);
    //this.SetDefaultValue();
}


function fn_keyEvent(){
    $("#entry_orderNo").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_confirmOrder();
            }
     });
}



function fn_getASHistoryInfo(){
	    Common.ajax("GET", "/services/as/getASHistoryList.do", {SALES_ORD_ID:'${as_ord_basicInfo.ordId}'  ,SALES_ORD_NO:'${as_ord_basicInfo.ordNo}'  }, function(result) {
            console.log("fn_getASHistoryInfo.");
            console.log( result);
            AUIGrid.setGridData(asHistoryGrid, result);
        });
}




function createASHistoryGrid(){
    
    var cLayout = [
         {dataField : "asNo",headerText : "AS No", width : 100},
         {dataField : "c2", headerText : "ASR No", width : 100 ,editable : false},
         {dataField : "code", headerText : "Status", width :80 ,editable : false},
         {dataField : "asReqstDt", headerText : "Request Date", width :100 ,editable : false  ,dataType : "date", formatString : "dd-mm-yyyy" },
         {dataField : "asSetlDt", headerText : "Settle Date", width :100 ,editable : false  ,dataType : "date", formatString : "dd-mm-yyyy" ,editable : false},
         {dataField : "c3", headerText : "Error Code", width :100 ,editable : false},
         {dataField : "c4", headerText : "Error Desc", width :100 ,editable : false},
         {dataField : "c5", headerText : "CT Code", width :100 ,editable : false},
         {dataField : "c6", headerText : "Solution", width :100 ,editable : false},
         {dataField : "c7", headerText : "Amount", width :80 ,dataType : "number", formatString : "#,000.00"  ,editable : false}
         
   ];
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount :1,selectionMode : "singleRow",  showRowNumColumn : true};  
    asHistoryGrid = GridCommon.createAUIGrid("#ashistory_grid_wrap", cLayout,'' ,gridPros); 
}


function createBSHistoryGrid(){
    
    var cLayout = [
         {dataField : "eNo",headerText : "BS No", width : 100 },
         {dataField : "edate", headerText : "BS Month", width : 100 ,editable : false},
         {dataField : "code", headerText : "Type", width :80 ,editable : false},
         {dataField : "code1", headerText : "Status", width :100 ,editable : false},
         {dataField : "no1", headerText : "BSR No", width :80 ,editable : false},
         {dataField : "c1", headerText : "Settle Date", width :80 ,dataType : "date", formatString : "dd-mm-yyyy" ,editable : false},
         {dataField : "memCode", headerText : "Cody Code", width :100 },
         {dataField : "code3", headerText : "Fail Reason", width :100 ,editable : false},
         {dataField : "code2", headerText : "Collection Reason", width :100 ,editable : false}
      
   ];
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount :1,selectionMode : "singleRow",  showRowNumColumn : true};  
    bsHistoryGrid = GridCommon.createAUIGrid("#bshistory_grid_wrap", cLayout,'' ,gridPros); 
}



function fn_doAllaction(){
	
    var ord_id = '143486';
    var  vdte =$("#appDate").val();
    
    
    var options ={
    		ORD_ID: ord_id,
    	    S_DATE: vdte,
    	    CTCodeObj : 'CTCodeObj',
    	    CTIDObj: 'CTIDObj',
    	    CTgroupObj:'CTgroupObj'
    }
    Common.popupDiv("/organization/allocation/allocation.do" ,{ORD_ID:ord_id  , S_DATE:vdte , OPTIONS:options }, null , true , '_doAllactionDiv');
    

}


function fn_getBSHistoryInfo(){
	    Common.ajax("GET", "/services/as/getBSHistoryList.do",{SALES_ORD_NO:'${as_ord_basicInfo.ordNo}' ,SALES_ORD_ID:'${as_ord_basicInfo.ordId}'  }, function(result) {
            console.log("fn_getBSHistoryInfo.");
            console.log( result);
            AUIGrid.setGridData(bsHistoryGrid, result);
        });
}

function fn_loadPageControl(){
    
    
    /*
    
    CodeManager cm = new CodeManager();
    IList<Data.CodeDetail> atl = cm.GetCodeDetails(10);
    
    ddlAppType_Search.DataTextField = "CodeName";
    ddlAppType_Search.DataValueField = "Code";
    ddlAppType_Search.DataSource = atl.OrderBy(itm=>itm.CodeName);
    ddlAppType_Search.DataBind();

    ASManager asm = new ASManager();
    List<ASReasonCode> ecl = asm.GetASErrorCode();
    ddlErrorCode.DataTextField = "ReasonCodeDesc";
    ddlErrorCode.DataValueField = "ReasonID";
    ddlErrorCode.DataSource = ecl.OrderBy(itm=>itm.ReasonCode);
    ddlErrorCode.DataBind();

    List<Data.Branch> dscl = cm.GetBranchCode(2, "-");
    ddlDSC.DataTextField = "Name";
    ddlDSC.DataValueField = "BranchID";
    ddlDSC.DataSource = dscl.OrderBy(itm=>itm.Code);
    ddlDSC.DataBind();

    List<ASMemberInfo> ctl = asm.GetASMember();
    ddlCTCode.DataTextField = "MemCodeName";
    ddlCTCode.DataValueField = "MemID";
    ddlCTCode.DataSource = ctl.OrderBy(itm=>itm.MemCode);
    ddlCTCode.DataBind();

    IList<Data.CodeDetail> rql = cm.GetCodeDetails(24);
    ddlRequestor.DataTextField = "CodeName";
    ddlRequestor.DataValueField = "CodeID";
    ddlRequestor.DataSource = rql.OrderBy(itm => itm.CodeName);
    ddlRequestor.DataBind();

    */
}




</script>
<div id="popup_wrap"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>AS ReceiveEntry</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><input type="text" title="" id="entry_orderNo" name="entry_orderNo"  value="${orderDetail.basicInfo.ordNo}" placeholder="" class="readonly " readonly="readonly" /><p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()">Reselect</a></p></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->


<div id='Panel_AS' style="display:inline" >
<section class="search_result"><!-- search_result start -->
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Order Info</a></li>
    <li><a href="#"  onclick="fn_gird_resize()">After Service</a></li>
    <li><a href="#" onclick="fn_gird_resize()">Before Service</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->


<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->


</article><!-- tap_area end -->


<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
   <div id="ashistory_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>  
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->



<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
   <div id="bshistory_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>  
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>AS Application Information</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="requestDate" name="requestDate"/>
    </td>
    <th scope="row">Request Time<span class="must">*</span></th>
    <td>

    <div class="time_picker w100p"><!-- time_picker start -->
    <input type="text" title="" placeholder="" class="time_date w100p" id="requestTime" name="requestTime"/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->

    </td>
    <th scope="row">Appointment Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="appDate" name="appDate" onChange="fn_doAllaction()"/>
    </td>
    <th scope="row">Appointment Time<span class="must">*</span></th>
    <td>

    <div class="time_picker w100p"><!-- time_picker start -->
    <input type="text" title="" placeholder="" class="time_date w100p" id="appTime" name="appTime"/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->

    </td>
</tr>
<tr>
    <th scope="row">Error Code<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="errorCode" name="errorCode">
    </select>
    </td>
    <th scope="row">Error Description<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="errorDesc" name="errorDesc">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DSC Branch<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="branchDSC" name="branchDSC">
    </select>
    </td>
    <th scope="row">CT Group<span class="must">*</span></th>
    <td>  <input type="text" title="" placeholder="" class="w100p" id="CTGroup" name="CTGroup"/>
    </td>
    <th scope="row">BS Within 30 Days</th>
    <td>
    <label><input type="checkbox" id="checkBS" name="checkBS"/></label>
    </td>
</tr>
<tr>
    <th scope="row">Assign CT<span class="must">*</span></th>
    <td colspan="3">  
           <input type="text" title="" placeholder="" id="CTCode" name="CTCode"/>
               <input type="text" title="" placeholder=""  id="CTID" name="CTID"/>
    </td>
    <th scope="row">Mobile No</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="mobileNo" name="mobileNo"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" id="checkSms" name="checkSms"/></label>
    </td>
</tr>
<tr>
    <th scope="row">Person Incharge</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="perIncharge"  name="perIncharge"/>
    </td>
    <th scope="row">Person Incharge Contact</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="perContact" name="perContact"/>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="3">Requestor<span class="must">*</span></th>
    <td colspan="3">
    <select class="w100p" id="requestor" name="requestor">
    </select>
    </td>
    <th scope="row">Requestor Contact</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="requestorCont" name="requestorCont"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" disabled="disabled" id="checkSms1" name="checkSms1"/></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Additional Contact</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="additionalCont" name="additionalCont"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" disabled="disabled" id="checkSms2" name="checkSms2"/></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row"> Allow Commission</th>
    <td colspan="3">
    <label><input type="checkbox" id="checkComm" name="checkComm"/></label>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="" id="remark"  name="remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onClick="fn_ASSave()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#">Clear</a></p></li>
</ul>

</section><!-- search_result end -->
</div>
</section><!-- content end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->