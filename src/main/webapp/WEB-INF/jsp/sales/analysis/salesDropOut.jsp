<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
	
	setDate();
	
	$("#dpSalesDateFr").datepicker({
		dateFormat: "dd/mm/yy",
		maxDate: -1  // AddDays(-1)
	}); 
	
	$("#dpSalesDateTo").datepicker({
        dateFormat: "dd/mm/yy",
        maxDate: -1
    }); 
	
});

function setDate(){
	
	$("#dpSalesDateFr").val("");
	$("#dpSalesDateTo").val("");
	
	var today = new Date();
    var max = (today.getDate()-1)+"/"+(today.getMonth()+1)+"/"+today.getFullYear();
    today = today.getDate()+"/"+(today.getMonth()+1)+"/"+today.getFullYear();

    if(today.substring(0,2) == "1/"){
        $("#dpSalesDateFr").val("01"+today.substring(1,9));
        $("#dpSalesDateTo").val("01"+today.substring(1,9));
    }else{
        $("#dpSalesDateFr").val("01"+today.substring(2,10));
        $("#dpSalesDateTo").val(max);
    }
	
}

function clearBtn(){

	setDate();
	document.getElementById("btnAll").checked = true;
	$("#cmbAppType").multipleSelect("checkAll"); 
	
}

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if(($("#dpSalesDateFr").val() == null || $("#dpSalesDateFr").val().length == 0) || ($("#dpSalesDateTo").val() == null || $("#dpSalesDateTo").val().length == 0)){
        valid = false;
        message += "* Please key in the Sales Date (From & To).\n";
    }
	if($('#cmbAppType :selected').length < 0){
		valid = false;
        message += "* Please select an Application Type.\n";
	}
	
	if(valid == false){
		Common.alert("Sales Dropout Listing" + DEFAULT_DELIMITER + message);
	}
	
	return valid;
	
}

function btnGenerate_Click(){
	
	if(validRequiredField()){
		
		$("#reportFileName").val("");
        $("#viewType").val("");
        $("#reportDownFileName").val("");
		
		var salesDateFrom = "";
        var salesDateTo = "";
        
        if(!($("#dpSalesDateFr").val() == null || $("#dpSalesDateFr").val().length == 0) && !($("#dpSalesDateTo").val() == null || $("#dpSalesDateTo").val().length == 0)){
        	var frArr = $("#dpSalesDateFr").val().split("/");
        	salesDateFrom = frArr[2]+"-"+frArr[1]+"-"+frArr[0]+" 00:00:00"; // yyyy-MM-dd hh:mm:ss
            var toArr = $("#dpSalesDateTo").val().split("/");
            salesDateTo = toArr[2]+"-"+toArr[1]+"-"+toArr[0]+" 00:00:00"; // yyyy-MM-dd hh:mm:ss
        }

        var runNo1 = 0;
        var appTypeJoin = "";
        if($('#cmbAppType :selected').length > 0){
            $('#cmbAppType :selected').each(function(j, mul){
                if($(mul).val() != "0"){
                    if(runNo1 > 0){
                    	appTypeJoin += ", "+$(mul).val();
                    }else{
                    	appTypeJoin += $(mul).val();
                    }
                    runNo1 += 1;
                }
            });
        } 
        
        var salesType = "";
         if($("input[name='searchby']:checked").val() == "btnAll"){
        	salesType = $("#btnAll").val();
        }else{
        	salesType = $("#btnOnly").val();
        } 
        
        $("#V_SALESDATEFROM").val(salesDateFrom);
        $("#V_SALESDATETO").val(salesDateTo);
        $("#V_APPTYPE").val(appTypeJoin);
        $("#V_SALESTYPE").val(salesType);
        
        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        } 
        $("#reportDownFileName").val("SalesDropout_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#viewType").val("EXCEL");
        $("#reportFileName").val("/sales/OrderDropoutListing_Excel.rpt");
                    
        // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
        var option = {
                isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
        };
                
        Common.report("form", option);
	}
}



</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Analysis</li>
    <li>Auto Debit & Aging</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Sales Dropout Listing</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Sales Date</th>
    <td>
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpSalesDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpSalesDateTo"/></p>
    </td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbAppType" data-placeholder="App Type">
        <option value="66" selected>Rental</option>
        <option value="67" selected>Outright</option>
        <option value="68" selected>Installment</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Sales Type</th>
     <td>
        <label><input type="radio" name="searchby" id="btnAll" value="btnAll" checked/><span>All Sales</span></label>
        <label><input type="radio" name="searchby" id="btnOnly" value="btnOnly"/><span>Drop Out Only</span></label>
     </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a onclick="javascript: btnGenerate_Click()">Generate to Excel</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript: clearBtn()">Clear</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />


<input type="hidden" id="V_SALESDATEFROM" name="V_SALESDATEFROM" value="" />
<input type="hidden" id="V_SALESDATETO" name="V_SALESDATETO" value="" />
<input type="hidden" id="V_APPTYPE" name="V_APPTYPE" value="" />
<input type="hidden" id="V_SALESTYPE" name="V_SALESTYPE" value="" />

</form>
</section><!-- search_table end -->

</section><!-- content end -->