<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">


var asHistoryGrid; 
var bsHistoryGrid; 
var ascallLogGridID;

$(document).ready(function(){
    fn_keyEvent();
    

    AUIGrid.resize(asHistoryGrid,1000,300); 
    AUIGrid.resize(bsHistoryGrid,1000,300); 
    AUIGrid.resize(ascallLogGridID,1000,200); 
    
    createASHistoryGrid();
    createBSHistoryGrid();
    
    fn_getASHistoryInfo();
    fn_getBSHistoryInfo();
    fn_setComboBox();
    
    
    
    fn_getErrMstList('${as_ord_basicInfo.ordNo}');
    
    
    <c:if test="${MOD eq 'VIEW'}">
    fn_setEditValue();
    createASCallLogAUIGrid();
    </c:if>
    
    if ( '${mafuncId}'   != "undefined"     &&   '${mafuncId}'  !=""  ) {
    	   //ASR인경우  SET ERRCODE 
        $("#errorCode").val('${mafuncId}' );
        $("#errorDesc").val('${mafuncResnId}' ); 
        $("#ISRAS").val("RAS");
    }
   
});



function fn_getErrMstList(_ordNo){
	
	 var SALES_ORD_NO = _ordNo ;
     $("#errorCode option").remove();
     doGetCombo('/services/as/getErrMstList.do?SALES_ORD_NO='+SALES_ORD_NO, '', '','errorCode', 'S' , '');            
}



function fn_errMst_SelectedIndexChanged(){
    
    var DEFECT_TYPE_CODE = $("#errorCode").val();
    
     $("#errorDesc option").remove();
     doGetCombo('/services/as/getErrDetilList.do?DEFECT_TYPE_CODE='+DEFECT_TYPE_CODE, '', '','errorDesc', 'S' , '');            
}






function fn_setComboBox(){
    doGetCombo('/common/selectCodeList.do', '24', '','requestor', 'S' , ''); 
    doGetCombo('/services/as/getBrnchId', '', '','branchDSC', 'S' , '');            // Customer Type Combo Box
}




function fn_setEditValue(){
        Common.ajax("GET", "/services/as/selASEntryView.do", {AS_NO:'${AS_NO}'   }, function(result) {
            console.log("fn_setEditValue.");
            
            var eOjb = result.asentryInfo;
            console.log( eOjb);
            
            

            $("#AS_PIC_ID").val(eOjb.asPicId) ;
            $("#AS_ID").val(eOjb.asId) ;
            $("#CTID").val(eOjb.asMemId) ;
            $("#CTGroup").val(eOjb.asMemGrp);
            $("#CTCode").val(eOjb.memCode);
            
            $("#requestDate").val(eOjb.asReqstDt);
            $("#requestTime").val(eOjb.asReqstTm);
            $("#appDate").val(eOjb.asAppntDt);
            $("#appTime").val(eOjb.asAppntTm);
            $("#branchDSC").val(eOjb.asBrnchId);
            $("#errorCode").val(eOjb.asMalfuncId);
            $("#errorDesc").val(eOjb.asMalfuncResnId);
            $("#requestor").val(eOjb.asRemReqster);
            $("#requestorCont").val(eOjb.asRemReqsterCntc);
            $("#txtRequestor").val(eOjb.asReqsterTypeId);
            $("#additionalCont").val(eOjb.asRemAddCntc);
            $("#CTSSessionCode").val(eOjb.asSesionCode);
            $("#perIncharge").val(eOjb.picName);
            $("#perContact").val(eOjb.picCntc);
            
            $('#perIncharge').removeAttr("readonly").removeClass("readonly");
            $('#perContact').removeAttr("readonly").removeClass("readonly");      
            
          
            if(eOjb.asIsBsWithin30days == "1")  $("#checkBS").attr("checked",true);
            else    $("#checkBS").attr("checked",false);
            
            if(eOjb.asAllowComm == "1") $("#checkComm").attr("checked",true);
            else     $("#checkComm").attr("checked",false);  
            
               
            if(eOjb.asRemReqsterCntcSms == "1")  $("#checkSms1").attr("checked",true);
            else   $("#checkSms1").attr("checked",false);
            
            if(eOjb.asRemAddCntcSms == "1")   $("#checkSms2").attr("checked",true);
            else   $("#checkSms2").attr("checked",false);
            
            
            
            fn_getCallLog();
        });
}





function fn_gird_resize(){

    AUIGrid.resize(asHistoryGrid,900,300); 
    AUIGrid.resize(bsHistoryGrid,900,300); 
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
	
	
    var ord_id ='${as_ord_basicInfo.ordId}'   ;// '143486';
    var  vdte   =$("#requestDate").val();
    
    
    var options ={
    		ORD_ID: ord_id,
    	    S_DATE: vdte,
    	    CTCodeObj : 'CTCodeObj',
    	    CTIDObj: 'CTIDObj',
    	    CTgroupObj:'CTgroupObj'
    }
    
    console.log("========>");
    console.log(options);
    Common.popupDiv("/organization/allocation/allocation.do" ,{ORD_ID:ord_id  , S_DATE:vdte , OPTIONS:options ,TYPE:'AS'}, null , true , '_doAllactionDiv');
}


function fn_getBSHistoryInfo(){
	    Common.ajax("GET", "/services/as/getBSHistoryList.do",{SALES_ORD_NO:'${as_ord_basicInfo.ordNo}' ,SALES_ORD_ID:'${as_ord_basicInfo.ordId}'  }, function(result) {
            console.log("fn_getBSHistoryInfo.");
            console.log( result);
            AUIGrid.setGridData(bsHistoryGrid, result);
        });
}





function fn_getMemberBymemberID(){
        Common.ajax("GET", "/services/as/getMemberBymemberID.do", {MEM_ID: $("#CTID").val() }, function(result) {
            console.log("fn_getMemberBymemberID.");
            console.log( result);
            
            if(result !=null) {
                $("#mobileNo").val(result.mInfo.telMobile);
            }
        });
}







function createASCallLogAUIGrid() {
    
    var columnLayout = [
                        {dataField : "callRem",     headerText  : "Remark" ,editable       : false  } ,
                        { dataField : "c2", headerText  : "KeyBy",  width  : 80 , editable       : false},
                        { dataField : "callCrtDt", headerText  : "KeyAt ",  width  : 120  ,dataType : "date", formatString : "dd/mm/yyyy" }
                     
   ];   
   
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true};  
    ascallLogGridID= GridCommon.createAUIGrid("ascallLog_grid_wrap", columnLayout  ,"" ,gridPros);
}
   
   

function fn_getCallLog(){
	Common.ajax("GET", "/services/as/getCallLog", {AS_ID: $("#AS_ID").val()}, function(result) {
        console.log("fn_getCallLog.");
        console.log( result);
        AUIGrid.setGridData(ascallLogGridID, result);
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


// $("#sForm").attr({"target" :"_self" , "action" : "/sales/membershipRentalQut/mNewQuotation.do" }).submit();



function fn_doReset(){
	
	try{
		$("#_resultNewEntryPopDiv1").remove();
		fn_newASPop();
		
	}catch(e){
		//콜센터 
		window.close();
	}
}


function fn_doSave(){
	  if( '${AS_NO}' !=""){
		  fn_doUpDate();
	  }else{
		  fn_doNewSave();
	  }
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



function fn_doUpDate(){

    if( fn_validRequiredField_Save()){
        var updateForm ={
                 "AS_SO_ID"                  : '${as_ord_basicInfo.ordId}' ,
                 "AS_MEM_ID"                : $("#CTID").val() ,
                 "AS_MEM_GRP"               : $("#CTGroup").val(),
                 "AS_REQST_DT"              : $("#requestDate").val(),
                 "AS_REQST_TM"              : $("#requestTime").val(),
                 "AS_APPNT_DT"              : $("#appDate").val(), 
                 "AS_APPNT_TM"              : $("#appTime").val(),      
                 "AS_BRNCH_ID"              : $("#branchDSC").val(),
                 "AS_MALFUNC_ID"            : $("#errorCode").val(),
                 "AS_MALFUNC_RESN_ID"       : $("#errorDesc").val(),
                 "AS_REM_REQSTER"           : $("#requestor").val(),
                 "AS_REM_REQSTER_CNTC"      : $("#requestorCont").val(),
                 "AS_CALLLOG_ID"            : '0',
                 "AS_STUS_ID"               : '1',
                 "AS_SMS"                  : '0',
                 "AS_ENTRY_IS_SYNCH"        : '0',   
                 "AS_ENTRY_IS_EDIT"         : '0',
                 "AS_TYPE_ID"               : '674',
                 "AS_REQSTER_TYPE_ID"       : $("#txtRequestor").val(),
                 "AS_IS_BS_WITHIN_30DAYS"   : $("#checkBS").prop("checked")   ? '1': '0',
                 "AS_ALLOW_COMM"            : $("#checkComm").prop("checked") ? '1': '0',
                 "AS_PREV_MEM_ID"           : 0,
                 "AS_REM_ADD_CNTC"          : $("#additionalCont").val(),
                 "AS_REM_REQSTER_CNTC_SMS"  : $("#checkSms1").prop("checked") ? '1': '0',
                 "AS_REM_ADD_CNTC_SMS"      : $("#checkSms2").prop("checked") ? '1': '0',
                 "AS_SESION_CODE"           : $("#CTSSessionCode").val(),
                 "CALL_MEMBER"              : '0',
                 "REF_REQUEST"              : '0' ,
                 "PIC_NAME" :$("#perIncharge").val(),
                 "PIC_CNTC" :$("#perContact").val(),
                 "AS_ID": $("#AS_ID").val(),
                 "AS_PIC_ID": $("#AS_PIC_ID").val()
        }
        
        console.log(updateForm);
            
        Common.ajax("POST", "/services/as/updateASEntry.do",updateForm , function(result) {
                    console.log("asupdate.");
                    console.log( result);
                    
                    $("#sFm").find("input, textarea, button, select").attr("disabled",true);
                    $("#save_bt_div").hide(); 
        });
    }
}

function  fn_doNewSave(){
	
	
	if( fn_validRequiredField_Save()){
		var saveForm ={
				 "AS_SO_ID"                  : '${as_ord_basicInfo.ordId}' ,
                 "AS_MEM_ID"                : $("#CTID").val() ,
                 "AS_MEM_GRP"               : $("#CTGroup").val(),
                 "AS_REQST_DT"              : $("#requestDate").val(),
                 "AS_REQST_TM"              : $("#requestTime").val(),
                 "AS_APPNT_DT"              : $("#appDate").val(), 
                 "AS_APPNT_TM"              : $("#appTime").val(),      
                 "AS_BRNCH_ID"              : $("#branchDSC").val(),
                 "AS_MALFUNC_ID"            : $("#errorCode").val(),
                 "AS_MALFUNC_RESN_ID"       : $("#errorDesc").val(),
                 "AS_REM_REQSTER"           : $("#requestor").val(),
                 "AS_REM_REQSTER_CNTC"      : $("#requestorCont").val(),
                 "AS_CALLLOG_ID"            : '0',
                 "AS_STUS_ID"               : '1',
                 "AS_SMS"                  : '0',
                 "AS_ENTRY_IS_SYNCH"        : '0',   
                 "AS_ENTRY_IS_EDIT"         : '0',
                 "AS_TYPE_ID"                     : $("#IN_AsResultId").val() ==  "" ? '674' : '2713'  ,
                 "AS_REQSTER_TYPE_ID"       : $("#txtRequestor").val(),
                 "AS_IS_BS_WITHIN_30DAYS"   : $("#checkBS").prop("checked")   ? '1': '0',
                 "AS_ALLOW_COMM"            : $("#checkComm").prop("checked") ? '1': '0',
                 "AS_PREV_MEM_ID"           : 0,
                 "AS_REM_ADD_CNTC"          : $("#additionalCont").val(),
                 "AS_REM_REQSTER_CNTC_SMS"  : $("#checkSms1").prop("checked") ? '1': '0',
                 "AS_REM_ADD_CNTC_SMS"      : $("#checkSms2").prop("checked") ? '1': '0',
                 "AS_SESION_CODE"           : $("#CTSSessionCode").val(),
                 "CALL_MEMBER"              : '0',
                 "REF_REQUEST"              : $("#IN_AsResultId").val() ,
                 "CALL_REM"                     :$("#callRem").val(),   
                 "PIC_NAME" :$("#perIncharge").val(),
                 "PIC_CNTC" :$("#perContact").val(),
                 "ISRAS" :     $("#ISRAS").val() 
		}
		
	    console.log(saveForm);
	        
	    Common.ajax("POST", "/services/as/saveASEntry.do",saveForm , function(result) {
	                console.log("asSave.");
	                console.log( result);
	                
	                if( result.logerr =="Y"){
	                	Common.alert("물류 오류 ..........." );
	                	return ;
	                }
	                
	                //인하우스 결과 등록 처리 
	               // if($("#IN_AsResultId").val() !="" ){
	               //     var param = "?ord_Id="+${as_ord_basicInfo.ordId}+"&ord_No="+${as_ord_basicInfo.ordNo}+"&as_No="+asNo+"&as_Id="+$("#AS_ID").val()+"&refReqst="+$("#IN_AsResultId").val() ;
	               //     Common.popupDiv("/services/as/ASNewResultPop.do"+param ,null, null , true , '_newASResultDiv1');
	               // }
	                
	                
	                
	                if(result.asNo !="" ){
	                	Common.alert("Save Quotation Summary" +DEFAULT_DELIMITER +"<b>New AS successfully saved.<br />AS number : [" + result.asNo  + "]</b>" );
	                	   
	                	if($("#checkSms").prop("checked")){
	                        Common.alert("SMS" +DEFAULT_DELIMITER +"SMS 발송 팝업 화면 호출 차후 개발 " );
	                		/*
	                		     string ASID = asEntryData.ASID.ToString();
	                            string ASNo = asEntryData.ASNo.ToString();
	                            string CTMemID = ddlCTCode.SelectedValue.ToString();
	                            string Message = this.GetSMSMessage(asEntryData,li);

	                            Message = Message.Replace("&", "$%$");
	                            Window_PopUp.NavigateUrl = "~/Services/AS/ASEntrySMS.aspx?ASID=" + ASID + "&ASNo=" + ASNo + "&CTMemID=" + CTMemID + "&Message=" + Message;
	                            Window_PopUp.VisibleOnPageLoad = true;    
	                          */
	                	}
	                	
	                	if($("#checkSms1").prop("checked")){
	                		  /*
	                		    string SMSMessage = "";
	                            DateTime dt = Convert.ToDateTime(dpAppDate.SelectedDate);
	                            string strDate = dt.ToShortDateString();
	                            SMSMessage="Order<"+txtOrderNo.Text+"> AS<"+asEntryData.ASNo+"> Appt Date<"+strDate+"> DSC<"+ddlDSC.SelectedItem.Text.Substring(0,6)+"> TQ"; 
	                            SendRequestorSMS(li,SMSMessage);
	                         */
	                    }
	                	

                        if($("#checkSms2").prop("checked")){
                        	  /*
	                            string SMSMessage = "";
	                            DateTime dt = Convert.ToDateTime(dpAppDate.SelectedDate);
	                            string strDate = dt.ToShortDateString();
	                            SMSMessage="Order<"+txtOrderNo.Text+"> AS<"+asEntryData.ASNo+"> Appt Date<"+strDate+"> DSC<"+ddlDSC.SelectedItem.Text.Substring(0,6)+"> TQ"; 
	                            SendRequestorSMS(li,SMSMessage);
	                         */
                        }
                        
                        
                        $("#sFm").find("input, textarea, button, select").attr("disabled",true);
                        $("#save_bt_div").hide(); 
	               }	
	    });
	}
	 
	
	
	
	/*
	 protected void btnSave_Click(object sender, EventArgs e)
	    {
	        Data.LoginInfo li = Session["login"] as Data.LoginInfo;
	        if (li != null)
	        {
	            if (this.validRequiredField_Save())
	            {
	                Data.ASEntry asEntryData = new Data.ASEntry();
	                asEntryData = this.GetSaveData_ASEntry(asEntryData, li);
	                string Remark = txtRemark.Text.Trim();
	                List<Data.ASPIC> asPICList = new List<Data.ASPIC>();
	                if (btnSMS.Checked &&
	                    ((!string.IsNullOrEmpty(txtPIC.Text.Trim())) ||
	                    (!string.IsNullOrEmpty(txtPICContact.Text.Trim()))))
	                    asPICList = this.GetSaveData_ASPICList(asPICList, li);
	                ASManager am = new ASManager();
	                asEntryData = am.DoSave_AS(asEntryData, asPICList, Remark);
	                if (asEntryData != null)
	                {
	                    RadWindowManager1.RadAlert("<b>New AS successfully saved.<br />AS number : [" + asEntryData.ASNo + "]</b>", 450, 160, "AS Successfully Saved", "callBackFn", null);
	                    if (btnSMS.Checked)
	                    {
	                        string ASID = asEntryData.ASID.ToString();
	                        string ASNo = asEntryData.ASNo.ToString();
	                        string CTMemID = ddlCTCode.SelectedValue.ToString();
	                        string Message = this.GetSMSMessage(asEntryData,li);

	                        Message = Message.Replace("&", "$%$");
	                        Window_PopUp.NavigateUrl = "~/Services/AS/ASEntrySMS.aspx?ASID=" + ASID + "&ASNo=" + ASNo + "&CTMemID=" + CTMemID + "&Message=" + Message;
	                        Window_PopUp.VisibleOnPageLoad = true;                       
	                    }
	                    
	                    if (btnRequestorSMS.Checked == true)
	                    {
	                        string SMSMessage = "";
	                        DateTime dt = Convert.ToDateTime(dpAppDate.SelectedDate);
	                        string strDate = dt.ToShortDateString();
	                        SMSMessage="Order<"+txtOrderNo.Text+"> AS<"+asEntryData.ASNo+"> Appt Date<"+strDate+"> DSC<"+ddlDSC.SelectedItem.Text.Substring(0,6)+"> TQ"; 
	                        SendRequestorSMS(li,SMSMessage);
	                    }

	                    if (btnAdditionalSMS.Checked == true)
	                    {
	                        string SMSMessage = "";
	                        SMSMessage = "COWAY RM0.00: Your order <" + txtOrderNo.Text + "> product issue had been successfully registered. Thank you!";
	                        SendAdditionalSMS(li, SMSMessage);
	                    }


	                    this.disabledPageControl();
	                }
	                else
	                {
	                    RadWindowManager1.RadAlert("<b>Failed to save new AS. Please try again later.</b>", 450, 160, "Failed To Save", "callBackFn", null);
	                }
	            }
	        }
	        else
	        {
	            RadWindowManager1.RadAlert("<b>Your login session has expired. Please relogin to our system.</b>", 450, 160, "Session Expired", "callBackFn", null);
	        }
	    }
	*/
}


function fn_validRequiredField_Save(){
	
	var rtnValue = true;
	var  rtnMsg="";

    if(FormUtil.checkReqValue($("#requestDate"))){
           rtnMsg  +="Please select the request date.<br>" ;
           rtnValue =false; 
    }else {
    	
    	 var  nowdate      = $.datepicker.formatDate($.datepicker.ATOM, new Date());
         var  nowdateArry  =nowdate.split("-");
                nowdateArry = nowdateArry[0]+""+nowdateArry[1]+""+nowdateArry[2];
         var  rdateArray   =$("#appDate").val().split("/");
         var requestDate  =rdateArray[2]+""+rdateArray[1]+""+rdateArray[0];
     
         if((parseInt(requestDate,10)  - parseInt(nowdateArry,10) ) > 14 || (parseInt(nowdateArry,10)  - parseInt(requestDate,10) )   >14){
            rtnMsg  +="* Request date should not be longer than 14 days from current date.<br />" ;
            rtnValue =false; 
        }
    }
    
    
    if(FormUtil.checkReqValue($("#requestTime"))){
        //rtnMsg  +="Please select the request time.<br/>" ;
        //rtnValue =false; 
    }
    
    
    if(FormUtil.checkReqValue($("#appDate"))){
	        rtnMsg  +="Please select the appDate date.<br>" ;
	        rtnValue =false; 
	 }else {
	     
	     var  nowdate      = $.datepicker.formatDate($.datepicker.ATOM, new Date());
	     var  nowdateArry  =nowdate.split("-");
	            nowdateArry = nowdateArry[0]+""+nowdateArry[1]+""+nowdateArry[2];
	     var  rdateArray   =$("#appDate").val().split("/");
	     var requestDate  =rdateArray[2]+""+rdateArray[1]+""+rdateArray[0];
	     
	     if((parseInt(requestDate,10)  - parseInt(nowdateArry,10) ) > 14 || (parseInt(nowdateArry,10)  - parseInt(requestDate,10) )   >14){
	         rtnMsg  +="* appDate date should not be longer than 14 days from current date.<br />" ;
	         rtnValue =false; 
	     }
	 }

    if(FormUtil.checkReqValue($("#appTime"))){
       // rtnMsg  +="Please select the appTime <br/>" ;
       // rtnValue =false; 
    }
    
    if($("#errorCode").val() == ""){
        rtnMsg += "* Please select the error code.<br />";
        rtnValue =false; 
    }
    
    if($("#errorDesc").val() == ""){
        rtnMsg += "* Please select the errorDesc.<br />";
        rtnValue =false; 
    }
    
    if($("#errorCode").val() == ""){
        rtnMsg += "* Please select the error code.<br />";
        rtnValue =false; 
    }
    
    if($("#errorCode").val() == ""){
        rtnMsg += "* Please select the error code.<br />";
        rtnValue =false; 
    }
    
    
    if($("#branchDSC").val() == ""){
        rtnMsg += "* Please select the DSC branch. <br />";
        rtnValue =false; 
    }
    
    /*
    if($("#CTGroup").val() == ""){
        rtnMsg += "* Please select the CTGroup. <br />";
        rtnValue =false; 
    }
    */
    if($("#CTCode").val() == ""){
        rtnMsg += "* Please select the CTCode. <br />";
        rtnValue =false; 
    }
    

    if($("#CTID").val() == ""){
        rtnMsg += "* Please select the CTID. <br />";
        rtnValue =false; 
    }
    
    if($("#requestor").val() == ""){
        rtnMsg += "* Please select the requestor. <br />";
        rtnValue =false; 
    }
    
    if($("#checkSms").prop("checked")){
        if($("#CTCode").val() != ""){
        	
        	 if($("#mobileNo").val() != ""){
                 //모바일 번호 vaild 체크 
             }else{
            	 rtnMsg += "* The CT does not has mobile number. SMS is disallowed.<br/>";
                 rtnValue =false; 
             }
        }
    }
    
    

    if( rtnValue ==false ){
        Common.alert("Save Quotation Summary" +DEFAULT_DELIMITER +rtnMsg );
    }
    
    return  rtnValue;
    
    
	/*
	
	 Boolean valid = true;
     string Mesage = "";
     if (string.IsNullOrEmpty(dpRequestDate.SelectedDate.ToString()))
     {
         Mesage += "* Please select the request date.<br />";
         valid = false;
     }
     else
     {
         DateTime selecteddate = Convert.ToDateTime(dpRequestDate.SelectedDate);
         DateTime currentdate = DateTime.Now;

         if ((selecteddate - currentdate).Days > 14 || (currentdate - selecteddate).Days > 14)
         {
             valid = false;
             Mesage += "* Request date should not be longer than 14 days from current date.<br />";
         }
     }
     if (string.IsNullOrEmpty(tpReqTime.SelectedTime.ToString()))
     {
         Mesage += "* Please select the request time.<br />";
         valid = false;
     }
     if (string.IsNullOrEmpty(dpAppDate.SelectedDate.ToString()))
     {
         Mesage += "* Please select the appointment date.<br />";
         valid = false;
     }
     else
     {
         DateTime selecteddate = Convert.ToDateTime(dpAppDate.SelectedDate);
         DateTime currentdate = DateTime.Now;

         if ((selecteddate - currentdate).Days > 14 || (currentdate - selecteddate).Days > 14)
         {
             valid = false;
             Mesage += "* Appointment date should not be longer than 14 days from current date.<br />";
         }
     }
     if (string.IsNullOrEmpty(tpAppTime.SelectedTime.ToString()))
     {
         Mesage += "* Please select the appointment time.<br />";
         valid = false;
     }
     if (ddlErrorCode.SelectedIndex <= -1)
     {
         Mesage += "* Please select the error code.<br />";
         valid = false;
     }
     if (ddlErrorDesc.SelectedIndex <= -1)
     {
         Mesage += "* Please select the error description.<br />";
         valid = false;
     }

     if (ddlDSC.SelectedIndex <= -1)
     {
         Mesage += "* Please select the DSC branch.<br />";
         valid = false;
     }
     if (ddlCTGroup.SelectedIndex <= -1)
     {
         Mesage += "* Please select the CT group.<br />";
         valid = false;
     }
     if (ddlCTCode.SelectedIndex <= -1)
     {
         Mesage += "* Please select the assign CT.<br />";
         valid = false;

     }
     if (ddlRequestor.SelectedIndex <= -1)
     {
         Mesage += "* Please select the requestor.<br />";
         valid = false;
     }

     if (btnSMS.Checked && ddlCTCode.SelectedIndex > -1)
     {
         if (!string.IsNullOrEmpty(txtCTMobile.Text.Trim()))
         {
             if (!CommonFunction.IsValidMobileNo(txtCTMobile.Text.Trim()))
             {
                 Mesage += "* Invalid CT mobile number. SMS is disallowed.<br />";
                 valid = false;
             }
         }
         else
         {
             Mesage += "* The CT does not has mobile number. SMS is disallowed.<br />";
             valid = false;
         }
     }

     if(!valid)
         RadWindowManager1.RadAlert("<b>" + Mesage + "</b>", 450, 160, "Save Summary", "callBackFn", null);
     return valid;
     */
	
	return rtnValue; 
}



function   fn_mobilesmschange(_obj){
	
	if(_obj.checked){
		$("#perContact").attr("disabled", false); 
        $("#perIncharge").attr("disabled", false);        
        $('#perIncharge').val('').removeAttr("readonly").removeClass("readonly");
        $('#perContact').val('').removeAttr("readonly").removeClass("readonly");        
        
    }else{
	    $("#perContact").attr("disabled", true); 
	    $("#perIncharge").attr("disabled", true); 
	}
}






function fn_changetxtRequestor (_obj){
    
    if(_obj.value !=""){
         if(! FormUtil.checkNum($("#txtRequestor"))){
          }else{
              Common.alert("Warning" +DEFAULT_DELIMITER +"<b>Only Digit available for txtRequestor  number</b>" );
              $("#txtRequestor").val(""); 
          }
    }
}


function fn_changeRequestorCont (_obj){
	
	if(_obj.value !=""){
		 if(! FormUtil.checkNum($("#requestorCont"))){
			 $("#checkSms1").attr("disabled", false); 
			 
	      }else{
	    	  Common.alert("Warning" +DEFAULT_DELIMITER +"<b>Only Digit available for Requestor SMS number</b>" );
	    	  $("#checkSms1").attr("disabled", true); 
	    	  $("#checkSms1").attr("checked",false);
	      }
    }else{
    	  $("#checkSms1").attr("disabled", true); 
          $("#checkSms1").attr("checked",false);
    }
}



function fn_changeAdditionalCont (_obj){
	
    if(_obj.value !=""){
         if(! FormUtil.checkNum($("#additionalCont"))){
             $("#checkSms2").attr("disabled", false); 
             
          }else{
              Common.alert("Warning" +DEFAULT_DELIMITER +"<b>Only Digit available for AdditionalCont SMS number</b>" );
              $("#checkSms2").attr("disabled", true); 
              $("#checkSms2").attr("checked",false);
          }
    }else{
    	   $("#checkSms2").attr("disabled", true); 
           $("#checkSms2").attr("checked",false);
  }
}



function fn_changeCTCode(_obj){
	if(_obj.value !=""){
		fn_getMemberBymemberID();
	}
	/*
	txtCTMobile.Text = "";
    if (ddlCTCode.SelectedIndex > -1)
    {
        Organization.Organization oo = new Organization.Organization();
        memberModel mm = new memberModel();
        mm = oo.GetMemberBymemberID(int.Parse(ddlCTCode.SelectedValue));
        if (mm != null)
        {
            txtCTMobile.Text = mm.member.TelMobile;
        }
    }
	*/
}


function fn_addRemark(){
    Common.popupDiv("/services/as/addASRemarkPop.do" ,{asId: $("#AS_ID").val()}, null , true , '_addASRemarkPopDiv');
}

</script>
<div id="popup_wrap"  class="popup_wrap "><!-- popup_wrap start -->
<section id="content"><!-- content start -->


<form action="#" method="post" id="sFm" name='sFm'>

<header class="pop_header"><!-- pop_header start -->
<h1>AS ReceiveEntry  <c:if test="${MOD eq 'VIEW'}">  EDIT  </c:if> </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->


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
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="requestDate" name="requestDate" onChange="fn_doAllaction()"/>
    </td>
    
    <th scope="row">Appointment Date<span class="must">*</span></th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p readonly"  readonly="readonly"   id="appDate" name="appDate" />
    </td>
    
    
    <th scope="row">Appointment <br> Sessione <span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder=""  id="CTSSessionCode" name="CTSSessionCode" class="readonly w100p"    readonly="readonly"  />
    <div class="time_picker w100p" style="display:none"><!-- time_picker start -->
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
   
    <th scope="row"></th>
    <td>

    <div class="time_picker w100p" style="display:none"><!-- time_picker start -->
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
    <select class="w100p" id="errorCode" name="errorCode"  onChange="fn_errMst_SelectedIndexChanged()"> 
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
       <!--  <input type="text" title="" placeholder="" class="w100p" id="branchDSC" name="branchDSC"  disabled="disabled" /> -->
     <select class="w100p" id="branchDSC" name="branchDSC"  class="readonly"  readonly="readonly" disabled="disabled">
    </select> 
    </td>
    <th scope="row">CT Group </th>
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
           <input type="text" title="" placeholder="" id="CTCode" name="CTCode"   class="readonly"  readonly="readonly"   onchange="fn_changeCTCode(this)"/>
    </td>
    <th scope="row">Mobile No</th>
    <td>
           <input type="text" title="" placeholder="" class="w100p" id="mobileNo" name="mobileNo"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" id="checkSms" name="checkSms"  onclick="fn_mobilesmschange(this)"/></label>
    </td>
</tr>
<tr>
    <th scope="row">Person Incharge</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly w100p"  id="perIncharge"  name="perIncharge"/>
    </td>
    <th scope="row">Person Incharge Contact</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly w100p"  id="perContact" name="perContact"/>
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
    <input type="text" title="" placeholder="" class="w100p" id="requestorCont" name="requestorCont" onchange="fn_changeRequestorCont(this)"/>
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" disabled="disabled" id="checkSms1" name="checkSms1"/></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <input type="text" title="" placeholder="" id='txtRequestor' name='txtRequestor' class="w100p"  onchage="fn_changetxtRequestor(this)"/>
    </td>
    <th scope="row">Additional Contact</th>
    <td>
    <input type="text" title="" placeholder="" class="w100p" id="additionalCont" name="additionalCont"  onchange="fn_changeAdditionalCont(this)"/>
    
    </td>
    <th scope="row">SMS</th>
    <td>
    <label><input type="checkbox" disabled="disabled" id="checkSms2" name="checkSms2"/></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    </td>
    <th scope="row"> Allow Commission</th>
    <td colspan="3">
    <label><input type="checkbox" id="checkComm" name="checkComm"/></label>
    </td>
</tr>


<c:if test="${MOD eq 'VIEW'}">
<tr>
    <th scope="row"></th>
    <td colspan="7"><p class="btn_sky"><a href="#" onclick="fn_addRemark()">add Remark</a></p></td>
</tr>
</c:if>
<c:if test="${MOD eq ''}">
    <tr>
        <th scope="row">Remark</th>
        <td colspan="7">
                <textarea  id='callRem' name='callRem'   rows='5' placeholder=""  class="w100p" ></textarea>
        </td>
    </tr>
 </c:if>   
    
</tbody>
</table><!-- table end -->



<c:if test="${MOD eq 'VIEW'}">
		<aside class="title_line"><!-- title_line start -->
		<h2>AS Call-Log Transaction</h2>
		</aside><!-- title_line end -->
		
		<article class="grid_wrap"><!-- grid_wrap start -->
		      <div id="ascallLog_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
</c:if>



<div style="display:none">
           <input type="text" title="" placeholder="ISRAS"  id="ISRAS" name="ISRAS"/>
           <input type="text" title="" placeholder="AS_ID"  id="AS_ID" name="AS_ID"  value="${AS_ID}"/>
           <input type="text" title="" placeholder="AS_PIC_ID"  id="AS_PIC_ID" name="AS_PIC_ID"/>
           <input type="text" title="" placeholder="CTID"  id="CTID" name="CTID"/>
           <input type="text" title="" placeholder="IN_AsResultId"  id="IN_AsResultId" name="IN_AsResultId" value="${IN_AsResultId}"/>
           <input type="text" title="" placeholder="mafuncResnId"  id="mafuncResnId" name="mafuncResnId" value="${mafuncResnId}"/>
           <input type="text" title="" placeholder="mafuncId"  id="mafuncId" name="mafuncId" value="${mafuncId}"/>
</div>

<ul class="center_btns" id='save_bt_div'>
    <li><p class="btn_blue2 big"><a href="#" onClick="fn_doSave()" >Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:$('#sFm').clearForm();" >Clear</a></p></li>
</ul>

</section><!-- search_result end -->
</div>
</section><!-- content end -->
</form>
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->

