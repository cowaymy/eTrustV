<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">


var oListGridID;
var bsHistoryGridID;


$(document).ready(function(){
    
    //AUIGrid 그리드를 생성합니다.
    createAUIGridOList();
    createAUIGridHList();
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(oListGridID, "cellDoubleClick", function(event) {  });

    $("#rbt").attr("style","display:none");
    $("#ORD_NO_RESULT").attr("style","display:none");
    
});



function setPackgCombo(){
	doGetCombo('/sales/membership/selectMembershipFree_Packg', '', '','cTPackage', 'S' , 'f_multiCombo');            // Customer Type Combo Box
}


function f_multiCombo(){
	
	$('#cTPackage').change(function() {
		$("#PAC_ID").val($(this).val());
		
		console.log(this)
	    Common.ajax("GET", "/sales/membership/selectMembershipFree_PChange", $("#getDataForm").serialize(), function(result) {
	        
		    	console.log(result);
		    	if(result.length > 0){
		    		   $("#bsFreq").html (result[0].srvMemItmPriod+" month(s)");
		    		   $("#duration").html (result[0].c1+" month(s)");
		    		   $("#TOYYMM").val (result[0].toyymm);
		    		   
	                    
		    	}else{
		    		 $("#bsFreq").html ("");
                     $("#duration").html ("");
                     $("#toyymm").html ("");
		    	     Common.alert("  Package Info Not Found <br> System unable to find the package info. Please try again later. ");
		    	}
	    });
    });
    
}

    
    
function fn_doConfirm (){
	Common.ajax("GET", "/sales/membership/selectMembershipFreeConF", $("#sForm").serialize(), function(result) {
		 console.log( result);
       
		// if (typeof (result[0].ordId ) == "undefined" ||  result[0].ordId =="") {
		if(result.length == 0)	{
			
			 $("#cbt").attr("style","display:inline");
			 $("#ORD_NO").attr("style","display:inline");
			 $("#sbt").attr("style","display:inline");
			 
			 
			 $("#rbt").attr("style","display:none");
			 $("#ORD_NO_RESULT").attr("style","display:none");
			 
			 $("#resultcontens").attr("style","display:none");
              
             Common.alert(" No order found or this order is not under complete status. ");
             return ;
             
		 }else{
			 
			 $("#ORD_ID").val( result[0].ordId);
			 $("#ORD_NO_RESULT").val( result[0].ordNo);
			 
			 
		     $("#cbt").attr("style","display:none");
             $("#ORD_NO").attr("style","display:none");
             $("#sbt").attr("style","display:none");
             
             

             $("#rbt").attr("style","display:inline");
             $("#ORD_NO_RESULT").attr("style","display:inline");
             $("#resultcontens").attr("style","display:inline");
             
             fn_getDataInfo();
             fn_getDataOList ();
             fn_getDatabsHistory();
             fn_outspro();
		 }
		
   });
}

	
function fn_getDataInfo (){
    Common.ajax("GET", "/sales/membership/selectMembershipFreeDataInfo", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         setText(result);
         setPackgCombo();
    });
 }
 
function fn_outspro (){
    Common.ajax("GET", "/sales/membership/callOutOutsProcedure", $("#getDataForm").serialize(), function(result) {
    	console.log(result);
    	
    	if(result.outSuts.length >0 ){
            $("#ordOtstnd").html (result.outSuts[0].ordOtstnd);
            $("#asOtstnd").html (result.outSuts[0].asOtstnd);
    	}
    });
 }


 /*oList*/ 
function fn_getDataOList (){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_oList", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         
         AUIGrid.setGridData(oListGridID, result);
         AUIGrid.resize(oListGridID, 1120,250);  
         
    });
  }
  
/*cPerson*/ 
function fn_getDataCPerson (){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_cPerson", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         //custCntc_Id     custInitial    codeName     nameName    dob    gender     raceId     codename1     telM1     telM2     telO     telR     telf     nric     pos     email     dept     stusCodeId     updUserId     updDt     idOld     dcm     crtUserId     crtDt   
     	//set 1ros
     	
     	fn_doClearPersion();
         
		$("#name").html(result[0].name);
		$("#gender").html(result[0].gender);
		$("#nric").html(result[0].nric);
		$("#codename1").html(result[0].codename1);
		$("#telM1").html(result[0].telM1);
		$("#telO").html(result[0].telO);
		$("#telR").html(result[0].telR);
		$("#telf").html(result[0].telf);
		$("#email").html(result[0].email);
		$("#SAVE_CUST_CNTC_ID").val(result[0].custCntcId);
		
         
    });
  }
  
  
 function fn_doClearPersion(){
	 
	 $("#name").html("");
     $("#gender").html("");
     $("#nric").html("");
     $("#codename1").html("");
     $("#telM1").html("");
     $("#telO").html("");
     $("#telR").html("");
     $("#telf").html("");
     $("#email").html("");
     $("#SAVE_CUST_CNTC_ID").val("");
 }
  
 /*bs_history*/ 
function fn_getDatabsHistory(){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_bs", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         

         AUIGrid.setGridData(bsHistoryGridID, result);
         AUIGrid.resize(bsHistoryGridID, 1120,250);  
         
    });
 }
 
 function  fn_goCustSearch(){
     Common.alert(" 차후 오더 조회  공통팝업 호출[미 개발] !!!  ");
 }
  


function setText(result){

	//if (typeof (result.basic.ordId) != "undefined"  &&   result.basic.ordId =="") {
		
		   console.log(result)
		    $("#ordNo").html(result.basic.ordNo);
	        $("#ordDt").html(result.basic.ordDt);
	        $("#InstallmentPeriod").html(result.basic.InstallmentPeriod);
	        $("#ordStusName").html(result.basic.ordStusName);
	        $("#rentalStus").html(result.basic.rentalStus);
	        $("#appTypeDesc").html(result.basic.appTypeDesc);
	        $("#ordRefNo").html(result.basic.ordRefNo);
	        $("#stockCode").html(result.basic.stockCode);
	        $("#stockDesc").html(result.basic.stockDesc);
	        $("#custId").html(result.basic.custId);
	        $("#custName").html(result.basic.custName);
	        $("#custNric").html(result.basic.custNric);
            $("#custType").html(result.basic.custType);
            
            $("#CUST_ID").val( result.basic.custId);
            $("#STOCK_ID").val( result.basic.stockId);
            $("#SAVE_SRV_CONFIG_ID").val(result.srvconfig.configId);
            
            if(result.srvconfig.exprtext =="Expired"){
            	 $("#expire").html( "<font color='Red'>"+result.srvconfig.exprtext+"</font>");
            	 $("#IS_EXPIRE").val("1"); 
            }else{
            	 $("#expire").html( result.srvconfig.exprtext);
            	 $("#IS_EXPIRE").val("0");
            }
           
	        
	        var address  =  result.installation.instAddr1 +" "+  
						            result.installation.instAddr2 +" "+
						            result.installation.instAddr3 +" "+
						            result.installation.instPostCode +" "+
						            result.installation.instArea+" "+ 
						            result.installation.instState +" "+ 
						            result.installation. instCnty;
								
			//$("#instalationAddress").html(address);
			$("#firstInstallNo").html(result.installation.firstInstallNo);
			$("#preferInstDt").html(result.installation.firstInstallDt);  
			
			
			if(result.basic.appTypeCode =="INS"){
				    $("#InstallmentPeriod").html(result.basic.InstallmentPeriod);
			}else{
			        $("#InstallmentPeriod").html("-");
			}
			
			if(result.basic.appTypeCode =="REN"){
				  	$("#rentalStus").html(result.basic.rentalStus );
			}else{
				  	$("#rentalStus").html("-");
			}
			
			
			fn_getDataCPerson();
		     
	//}
}




function createAUIGridOList() {
    
    //AUIGrid 칼럼 설정
    var columnLayout = [
                        {     dataField     : "stkCode",                 
                               headerText  : "Code",  
                               width          : "10%",               
                               editable       : false
                        }, 
                        {     dataField     : "stkDesc",          
                               headerText  : "Name",           
                               width          : "60%",                
                               editable       : false,     
                               style           : 'left_style'
                        }, 
                        {     dataField     : "code",                     
                               headerText  : "Type",           
                               width          : "10%",                 
                               editable       : false
                        }, 
                        {      dataField     : "srvFilterPriod",                
                                headerText  : "Change Period",           
                                width          : "10%",                 
                                editable       : false
                        }, 
                    {      dataField       : "srvFilterPrvChgDt",      
                                headerText   : "Last Change",           
                                width           : "10%",                 
                                editable        : false
                         }
                        
   ];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,             //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable                : false,            
        fixedColumnCount    : 1,            
        showStateColumn     : true,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
    };
    
    oListGridID = GridCommon.createAUIGrid("oList_grid_wrap", columnLayout, "", gridPros);
}




function createAUIGridHList() {
    
    //AUIGrid 칼럼 설정
    var columnLayout = [
                        {     dataField     : "no",                 
                               headerText  : "BS No",  
                               width          : 150,               
                               editable       : false
                        }, 
                        {     dataField     : "month",          
                               headerText  : "BS Month",           
                               width          : 100,                
                               editable       : false
                        }, 
                        {     dataField     : "code",                     
                               headerText  : "Type",           
                               width          : 100,                 
                               editable       : false
                        }, 
                        {      dataField     : "code1",                
                                headerText  : "Status",           
                                width          :100,                 
                                editable       : false
                        }, 
                        {      dataField       : "no1",      
                            headerText   : "BSR No",           
                            width           : 150,                 
                            editable        : false
                     },
                    {      dataField       : "c1",      
                                headerText   : "Settle Date",           
                                width           : 200,                 
                                editable        : false
                         }, 
                         {      dataField       : "memCode",      
                             headerText   : "Cody Code",           
                             width           : 100,                 
                             editable        : false
                      }, 
                      {      dataField       : "code3",      
                          headerText   : "Fail Reason",           
                          width           :100,                 
                          editable        : false
                   }, 
                   {      dataField       : "code2",      
                       headerText   : "Collection Reason",           
                       width           : 150,                 
                       editable        : false
                }
                        
   ];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,             //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable                : false,            
        fixedColumnCount    : 1,            
        showStateColumn     : true,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
    };
    
    bsHistoryGridID = GridCommon.createAUIGrid("hList_grid_wrap", columnLayout, "", gridPros);
}


function fn_doReset() {
    window.close();
}





function fn_addContactPersonInfo(objInfo){
          console.log(objInfo);       
          
          fn_doClearPersion();
          
          $("#name").html(objInfo.name);
          $("#gender").html(objInfo.gender);
          $("#nric").html(objInfo.nric);
          $("#codename1").html(objInfo.codename1);
          $("#telM1").html(objInfo.telM1);
          $("#telO").html(objInfo.telO);
          $("#telR").html(objInfo.telR);
          $("#telf").html(objInfo.telf);
          $("#email").html(objInfo.email);
          $("#SAVE_CUST_CNTC_ID").val(objInfo.custCntcId);
          
          
}


function  fn_goContactPersonPop(){
    Common.popupDiv("/sales/membership/memberFreeContactPop.do");
}


function  fn_goNewContactPersonPop(){
    Common.popupDiv("/sales/membership/memberFreeNewContactPop.do");
}


function fn_doSave(){
	
	if (fn_validReqField()){
			 if (fn_validStartDate() ){
				   var aList  = new Array();
				 
				    $("#SAVE_ORD_ID").val($("#ORD_ID").val());
				    $("#SAVE_PAC_ID").val($("#PAC_ID").val());
				    $("#SAVE_BS_FREQ").val(($("#bsFreq").text()).replace(" month(s)",""));    
				    
				    aList = $("#mypStartDate").val().split("/");
				    
				    $("#SAVE_START_DATE").val(aList[1]+"-"+aList[0]+"-");
				    $("#SAVE_DURATION").val(($("#duration").text()).replace(" month(s)",""));
				 
				    Common.ajax("GET", "/sales/membership/selectMembershipFree_save", $("#saveForm").serialize(), function(result) {
				    	
	                    var resultFalge = false;
				    	if(result.resultIntKey  != "0" ) resultFalge=true;
				    	
					    
					    if(resultFalge){
					    	Common.alert("<b>Free membership successfully given to this order.</b>");
					    	fn_doConfirm ();
					    
					    }else {
					    	Common.alert(" <b>Failed to save free membership. Please try again later.</b>");
					    }
				   });
				   
				   
			 }else{
				   if(  $("#IS_EXPIRE").val() == 0){
							 Common.alert(" <b>Invalid start date.<br />Start date month must greater than last expired date.</b>");
							 return ;
					}else{
							 Common.alert(" <b>Invalid start date.<br /> Start date month must greater than/equal to current month.</b>");
							 return ;
					}
			 }
	}
}


function fn_validReqField(){
	 
	 if($("#cTPackage").val() =="") {
		 Common.alert(" You must fill up [Type of Package]  the required fields.  ");
		 return false; 
	 }
    
	 if($("#mypStartDate").val() =="") {
		 Common.alert(" You must fill up [Start Date] the required fields. ");
         return false; 
     }
	 return true;
}


/*
 *expire가 되지 않았을 경우  
 *  선택된 날짜(년월)와 expire날짜(년월)을 가지고 비교하여 선택 날짜가 크면 true 리턴  
 */
function fn_validStartDate(){
	
	var rtnFlag =false; 
	var aList  = new Array();
	var compareDate  = $("#TOYYMM").val();
	var  selectedDate = ($("#mypStartDate").val());
	
	 
    aList = selectedDate.split("/");
    selectedDate=aList[1]+""+aList[0];
      
    console.log("compareDate["+compareDate+"]selectedDate["+selectedDate+"]IS_EXPIRE["+$("#IS_EXPIRE").val()+"]");
      
	
	if(  $("#IS_EXPIRE").val() == 0){
		 //compareDate = FormUtil.convertStrToDateFormat($("#expire").text() ,"yyyyMM" ,"" ); 
		
		 //dd-mm-yyyy
		 aList = $("#expire").text() .split("-");
		 compareDate = aList[2]+""+aList[1];
			 
		 console.log("IS_EXPIRE   IN ..... compareDate["+compareDate+"]selectedDate["+selectedDate+"]");
		 if (parseInt(selectedDate,10)  > parseInt(compareDate,10)){
			 rtnFlag  =true; 
         }
		 
	}else {
		if (parseInt(selectedDate,10) >= parseInt(compareDate,10))  {
			rtnFlag  = true;
        }
	}
	
	return rtnFlag; 
}


function fn_close(){
	
	window.close();
}

</script>



<div id="popup_wrap" class="popup_wrap  pop_win"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Management - Free Membership</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->




<section id="content"><!-- content start -->



<form id="getDataForm" method="post">
<div style="display:none">
    <input type="text" name="ORD_ID"     id="ORD_ID"/>  
    <input type="text" name="CUST_ID"    id="CUST_ID"/>  
    <input type="text" name="IS_EXPIRE"  id="IS_EXPIRE"/>   <!--  1: EXPIRE  -->
    <input type="text" name="STOCK_ID"  id="STOCK_ID"/>  
    <input type="text" name="PAC_ID"  id="PAC_ID"/>  
    <input type="text" name="TOYYMM"  id="TOYYMM"/>  
</div>
</form>




<aside class="title_line"><!-- title_line start -->
<h3>Select Order</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="sForm"  name="sForm" method="post">




<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>  
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr >
    <th scope="row"  >Order No</th>
    <td >
 
          <input type="text" title="" id="ORD_NO" name="ORD_NO" placeholder="" class="" /><p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> Confirm</a></p>   <p class="btn_sky" id='sbt'><a href="#" onclick="javascript: fn_goCustSearch()">Search</a></p>
          <input type="text" title="" id="ORD_NO_RESULT" name="ORD_NO_RESULT"   placeholder="" class="readonly " readonly="readonly" /><p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()">Reselect</a></p>
    
	    </div> 
    </td>
</tr>



</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->


<section id="resultcontens"   style="display:none">


<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Membership Info</a></li>
	<li><a href="#"   id='orderTab' onclick=" javascript:AUIGrid.resize(oListGridID, 1120,300);" >Order Info</a></li>
	<li><a href="#">Contact Person</a></li>
	<li><a href="#" onclick="javascript:AUIGrid.resize(bsHistoryGridID, 1120,400); " >BS History</a></li>
	
</ul>


 
<!-- inc_membershipInfo  tab  start...-->
     <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_membershipInfo.do?MBRSH_ID=${MBRSH_ID}'/>   
<!--  inc_membershipInfotab  end...-->




<article class="tap_area" ><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><span id="ordNo"></span></td>  
    <th scope="row">Order Date</th>
    <td><span id='ordDt'></span></td>
    <th scope="row">Installment Period</th>
    <td><span id='InstallmentPeriod'></span></td>
</tr>
<tr>
    <th scope="row">Order Status</th>
    <td><span id='ordStusName'></span></td>
    <th scope="row">Rental Status</th>
    <td><span id='rentalStus'></span></td>
    <th scope="row">Install No</th>
    <td><span id='firstInstallNo'></span></td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td><span id='appTypeDesc'></span></td>
    <th scope="row">Reference No</th>
    <td><span id='ordRefNo'></span></td>
    <th scope="row">Install Date</th>
    <td><span id='preferInstDt'></span></td>
</tr>
<tr>
    <th scope="row">Stock Code</th>
    <td><span id='stockCode'></span></td>
    <th scope="row">Stock Name</th>
    <td colspan="3" id='stockDesc' ><span></span></td>
</tr>
<tr>
    <th scope="row" rowspan="3">Instalation Address</th>
    <td colspan="3" rowspan="3"><span id='instalationAddress'></span></td>
    <th scope="row">Order Outstanding</th> 
    <td><span id="ordOtstnd"></span></td>
</tr>
<tr>
    <th scope="row">AS Outstanding</th>
    <td><span  id="asOtstnd"></span></td>
</tr>
<tr>
    <th scope="row">Membership Expire</th>
    <td><span id="expire"></span></td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><span id='custId'></span></td>
    <th scope="row">Customer Type</th>
    <td colspan="3" id='custType'><span></span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="5" id='custName'><span></span></td>
</tr>
<tr>
    <th scope="row">NRIC/Company No</th>
    <td colspan="5" id='custNric'><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

 
 <article class="grid_wrap"><!-- grid_wrap start -->
      <div id="oList_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
 </article><!-- grid_wrap end -->

</article><!-- tap_area end -->




<article class="tap_area"><!-- tap_area start -->

<ul class="left_btns mb10">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_goContactPersonPop()">Other Contact Person</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_goNewContactPersonPop()">New Contact Person</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td colspan="5" id="name"><span></span></td>
    <th scope="row"></th>
    <td><span id="gender"></span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td colspan="5" id="nric"><span></span></td>
    <th scope="row">Race</th>
    <td><span id="codename1"></span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span id="telM1"></span></td>
    <th scope="row">Office No</th>
    <td><span id="telO"></span></td>
    <th scope="row">Residence No</th>
    <td><span id="telR" ></span></td>
    <th scope="row">Fax No</th>
    <td><span id="telf"></span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td colspan="7" id="email"><span></span></td>
</tr>
</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->





<article class="tap_area"><!-- tap_area start -->


<article class="grid_wrap"><!-- grid_wrap start -->
  <div id="hList_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->




</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Free Membership Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#"  id="saveForm"  name="saveForm"  method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Type of Package</th>
	<td>
	    <select id="cTPackage" name="cTPackage" class="w100p" >
        </select>
	</td>
	<th scope="row">Start Date</th>
	<td><input type="text" title="기준년월" placeholder="DD/MM/YYYY" class="j_date2 w100p"  id="mypStartDate"  name='mypStartDate'/></td>
</tr>
<tr>
	<th scope="row">Membership Duration</th>
	<td><span id='duration'></span></td>
	<th scope="row">BS Frequency</th>
	<td><span id='bsFreq'></span></td>
</tr>

<tr>
	<th scope="row">Remark</th>
	<td colspan="3"><textarea cols="20" rows="5" id='remark'  name='remark'></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<div  style="display:none">
	<input type="text" name="SAVE_ORD_ID"  id="SAVE_ORD_ID"/>  
	<input type="text" name="SAVE_PAC_ID"  id="SAVE_PAC_ID"/>  
	<input type="text" name="SAVE_BS_FREQ"  id="SAVE_BS_FREQ"/>  
	<input type="text" name="SAVE_START_DATE"  id="SAVE_START_DATE"/>  
	<input type="text" name="SAVE_DURATION"  id="SAVE_DURATION"/>  
	<input type="text" name="SAVE_CUST_CNTC_ID"  id="SAVE_CUST_CNTC_ID"/>  
	<input type="text" name="SAVE_SRV_CONFIG_ID"  id="SAVE_SRV_CONFIG_ID"/>  
</div>

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_doSave()">SAVE</a></p></li>
</ul>

</section><!-- content end -->

</section>

</section>
</div>

<script>

</script>