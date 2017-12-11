<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">
	
function cboGroup_SelectedIndexChanged(){
    
    var total_item = new Array();
    var i = 0;
    $('#cboGroup :selected').each(function(j, mul){ 
       total_item[i] = $(mul).val();
        i++;
    });
  
    CommonCombo.make('cboDepartment', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 3, parentID : total_item}, '', {type:'M', isCheckAll:false});
    
    $("#cboDepartment").multipleSelect("enable");
 //   $("#cboMember").multipleSelect("enable");
    
}

function cboOrganization_SelectedIndexChanged(){
    
    var total_item = new Array();
    var i = 0;
    $('#cboOrganization :selected').each(function(j, mul){ 
        total_item[i] = $(mul).val();
        i++;
    });

    CommonCombo.make('cboGroup', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 2, parentID : total_item}, '', {type:'M', isCheckAll:false});
   
    $("#cboGroup").multipleSelect("enable");
    $("#cboDepartment").multipleSelect("disable");
//    $("#cboMember").multipleSelect("enable");
     
}

function cboMember_SelectedIndexChanged(){

    $("#cboOrganization").multipleSelect("disable");
    $("#cboGroup").multipleSelect("disable");
    $("#cboDepartment").multipleSelect("disable");
   
	if(parseInt($("#cboMember :selected").val()) < 4){
		
		var arrparentID0 = 3487;
		var arrparentID1 = 31983;
		var arrparentID2 = 23259;
		
		if($("#cboMember :selected").val() == "1"){
			CommonCombo.make('cboOrganization', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 1, parentID : arrparentID0}, '', {type:'M', isCheckAll:false});			
		}else if($("#cboMember :selected").val() == "2"){
			CommonCombo.make('cboOrganization', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 1, parentID : arrparentID1}, '', {type:'M', isCheckAll:false});
        }else if($("#cboMember :selected").val() == "3"){
        	CommonCombo.make('cboOrganization', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 1, parentID : arrparentID2}, '', {type:'M', isCheckAll:false});
        }
		
		$("#cboOrganization").multipleSelect("enable");
		$("#cboGroup").multipleSelect("disable");
	    $("#cboDepartment").multipleSelect("disable");
//		$("#cboMember").multipleSelect("enable");
	    
	}else{
		
		var arrparentID0 = 0;  
		CommonCombo.make('cboDepartment', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 4, parentID : arrparentID0}, '', {type:'M', isCheckAll:false});
		
		$("#cboOrganization").multipleSelect("disable");
	    $("#cboGroup").multipleSelect("disable");
		$("#cboDepartment").multipleSelect("enable");
   //     $("#cboMember").multipleSelect("enable");
	}
	
}


function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if(($("#rdpDateTo").val() == null || $("#rdpDateTo").val().length == 0) || ($("#rdpDateFrom").val() == null || $("#rdpDateFrom").val().length == 0)){
		valid = false;
		message += "* Please select the date closed (From & To).\n";
	}
	
	if(!($("#rdpDateTo").val() == null || $("#rdpDateTo").val().length == 0) || !($("#rdpDateFrom").val() == null || $("#rdpDateFrom").val().length == 0)){
		
		var frArr = $("#rdpDateFrom").val().split("/");
	    var toArr = $("#rdpDateTo").val().split("/");
		var datefrom = new Date(frArr[1]+"/"+frArr[0]+"/"+frArr[2]);
		var dateto = new Date(toArr[1]+"/"+toArr[0]+"/"+toArr[2]);
		var day = 60 * 60 * 24 * 1000;
		
		if((datefrom.getTime() + 30*day) < dateto){
			valid = false;
            message += "* Interval of date closed cannot exceed 30 days.\n";
		}			 
	}
	
	if(valid == false){
        Common.alert("Report Generate Summary" + DEFAULT_DELIMITER + message);

    }else{
    	btnGenerateExcel_Click();
    }
    
}

function btnGenerateExcel_Click(){
	
	var dateclosed = "";
	var losttype = "";
	var tRNo = "";
	var tRBookNo = ""; 
	var keyInBranch = 0;
	var keyInUser = "";
	
	var whereSQL = "";
	
	if(!($("#rdpDateTo").val() == null || $("#rdpDateTo").val().length == 0) || !($("#rdpDateFrom").val() == null || $("#rdpDateFrom").val().length == 0)){
		whereSQL += " AND t.DATECLOSED >= TO_DATE('"+$("#rdpDateFrom").val()+"', 'dd/MM/YY') AND t.DATECLOSED <= TO_DATE('"+$("#rdpDateTo").val()+"', 'dd/MM/YY')";
	}
	
	if(!($("#txtTRFrom").val().trim() == null || $("#txtTRFrom").val().trim().length == 0) || !($("#txtTRTo").val().trim() == null || $("#txtTRTo").val().trim().length == 0)){
		whereSQL += " AND (t.TR_NO BETWEEN '"+$("#txtTRFrom").val().trim()+"' AND '"+$("#txtTRTo").val().trim()+"')";
	}
	
	if(!($("#txtTRBookNo").val().trim() == null || $("#txtTRBookNo").val().trim().length == 0)){
		whereSQL += " AND t.TRBNUMBER = '"+$("#txtTRBookNo").val().trim()+"' ";
	}
	
	 if($('#cmbLostType :selected').length > 0){
         whereSQL += " AND (";
         var runNo = 0;
         
         $('#cmbLostType :selected').each(function(i, mul){ 
             if(runNo == 0){
                 if($(mul).val() == "pieces"){
                	 losttype = "Piece";
                     whereSQL += "t.LOSTTYPE = '"+losttype+"' ";
                 }else{
                	 losttype = "Whole Book";
                     whereSQL += "t.LOSTTYPE LIKE '%whole%' ";
                 }
	
             }else{
            	 if($(mul).val() == "pieces"){
                     losttype = "Piece";
                     whereSQL += " OR t.LOSTTYPE = '"+losttype+"' ";
                 }else{
                     losttype = "Whole Book";
                     whereSQL += " OR t.LOSTTYPE LIKE '%whole%' ";
                 }
             }
             runNo += 1;
         });
         whereSQL += ") ";
	 }
	
	if($("#cmbBranch :selected").index() > 0){
		keyInBranch = parseInt($("#cmbBranch :selected").val());
		whereSQL += " AND t.BRNCH_ID = '"+keyInBranch+"' ";
	}
	
	if(!($("#txtKeyInUser").val().trim() == null || $("#txtKeyInUser").val().trim().length == 0)){
		keyInUser = $("#txtKeyInUser").val().trim();
		whereSQL += " AND t.USER_NAME = '"+keyInUser+"' ";
	}
	
	var showKeyDepartment = "-";
	if($("#cboMember :selected").index() > 0){
		
		var mbrID = "";
		var mbrID1 = "";
		var mbrID2 = "";
		var mbrID3 = "";
		if(parseInt($("#cboMember :selected").val()) == 4){
			
			var cnt = 0;
			$('#cboDepartment :selected').each(function(i, mul){ 
				if(cnt == 0){
					mbrID += $(mul).val();
				}else{
					mbrID += ", "+$(mul).val();
				}
				cnt += 1;
			});
			whereSQL += " AND t.MEM_ID IN ("+mbrID+") ";
		}else{
			
			var cnt = 0;
			if($('#cboOrganization :selected').length > 0){
				$('#cboOrganization :selected').each(function(i, mul){ 
					if(cnt == 0){
						mbrID1 += " '"+$(mul).val().substring(0, 7)+"' ";
					}else{
						mbrID1 += ", '"+$(mul).val().substring(0, 7)+"' ";
					}
					cnt += 1;
				});
			//	whereSQL += " AND mbr.MEM_ID IN ("+mbrID+") ";
			}
			
			if($('#cboGroup :selected').length > 0){
				$('#cboGroup :selected').each(function(i, mul){ 
					if(cnt == 0){
						mbrID2 += " '"+$(mul).val().substring(0, 7)+"' ";
                    }else{
                    	mbrID2 += ", '"+$(mul).val().substring(0, 7)+"' ";
                    }
                    cnt += 1;
				});
			//	whereSQL += " AND mbr.MEM_ID IN ("+mbrID+") ";
			}
			
			if($('#cboDepartment :selected').length > 0){
				$('#cboDepartment :selected').each(function(i, mul){ 
					if(cnt == 0){
						mbrID3 += " '"+$(mul).val().substring(0, 7)+"' ";
                    }else{
                    	mbrID3 += ", '"+$(mul).val().substring(0, 7)+"' ";
                    }
                    cnt += 1;
				});
			//   whereSQL += " AND mbr.MEM_ID IN ("+mbrID+") ";	
			}
			//showKeyDepartment = $('#cboDepartment :selected').text();
			whereSQL += " AND t.DEPT_CODE IN ("+mbrID1+mbrID2+mbrID3+") ";
		}
	}
		
	var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
    $("#reportDownFileName").val("TRBookLostReport_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#viewType").val("EXCEL");
    $("#reportFileName").val("/sales/TRBook_LostReport.rpt");
    
    $("#V_WHERESQL").val(whereSQL);
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  
    };
    
    Common.report("form", option);
	
}


$(document).ready(function() {

	CommonCombo.make('cmbBranch', '/sales/ccp/getBranchCodeList', '' , '');
    
     /* 멀티셀렉트 플러그인 start */
    $('.multy_select').change(function() {
       //console.log($(this).val());
    })
    .multipleSelect({
       width: '100%'
    });
    
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    } 
    $("#rdpDateFrom").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    $("#rdpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    
    CommonCombo.make('cboOrganization', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 1}, '', {type:'M', isCheckAll:false});
    CommonCombo.make('cboGroup', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 2}, '', {type:'M', isCheckAll:false});
    CommonCombo.make('cboDepartment', '/sales/trBook/getOrganizationCodeList', {memType : $("#cboMember").val(), memLvl : 3}, '', {type:'M', isCheckAll:false});

    $("#cmbLostType").multipleSelect("checkAll");
    $("#cboOrganization").multipleSelect("enable");
    $("#cboGroup").multipleSelect("disable");
    $("#cboDepartment").multipleSelect("disable");

});


</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>TR Book Report - Lost Report List</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Date Closed</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="rdpDateFrom"/></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="rdpDateTo"/></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row">Lost Type</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cmbLostType">
            <option value="pieces" selected>Pieces</option>
            <option value="whole_book" selected>Booklet</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row">TR No.</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" name="" class="w100p" id="txtTRFrom"></p>
        <span>To</span>
        <p><input type="text" name="" class="w100p" id="txtTRTo"></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row">Key-In Branch</th>
    <td><select data-placeholder="Key-In Branch" class="w100p" id="cmbBranch">
                <option value="0">All</option>
           </select>
    </td>
</tr>
<tr>
    <th scope="row">TR Book No.</th>
        <td><input type="text" title="" placeholder="TR Book No" class="w100p" id="txtTRBookNo"/></td>
    <th scope="row">Key-In User</th>
    <td><input type="text" title="" placeholder="Key-In User" class="w100p" id="txtKeyInUser"/></td>
</tr>
<tr>
    <th scope="row">Member Type</th>
    <td>
        <select class="w100p" id="cboMember" onchange="cboMember_SelectedIndexChanged()" data-placeholder="Member Type">
            <option value="1">Health Planner</option>
            <option value="2">Coway Lady</option>
            <option value="3">Coway Technician</option>
            <option value="4">Staff</option>
        </select>
    </td>
    <th scope="row">Organization Code</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboOrganization" onchange="cboOrganization_SelectedIndexChanged()" data-placeholder="Organization Code" disabled></select>
    </td>
</tr>
<tr>
    <th scope="row">Group Code</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboGroup" onchange="cboGroup_SelectedIndexChanged()" data-placeholder="Group Code" disabled></select>
    </td>
    <th scope="row">Department Code</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cboDepartment" data-placeholder="Department Code" disabled></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript: validRequiredField()">Generate To Excel</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->