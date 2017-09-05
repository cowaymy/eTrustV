
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<style>

/* 커스텀 행 스타일 */
.my-row-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javaScript" language="javascript">

var oListGridID;
var bsHistoryGridID;

$(document).ready(function(){
    
    createAUIGridHList();
    createAUIGridOList();
    
    $("#rbt").attr("style","display:none");
    $("#ORD_NO_RESULT").attr("style","display:none");
    
});




function fn_doConfirm (){
    Common.ajax("GET", "/sales/membership/selectMembershipFreeConF", $("#sForm").serialize(), function(result) {
         console.log( result);
  
         if(result.length == 0)  {
            
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
        	$("#ordoutstanding").html(result.outSuts[0].ordOtstnd);
        	$("#asoutstanding").html(result.outSuts[0].asOtstnd);
        }
    });
 }
 

function setText(result){
	
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
    $("#coolingOffPeriod").html(result.basic.coolOffPriod);
    
   
    
    var address  =  result.installation.instAddr1 +" "+  
                            result.installation.instAddr2 +" "+
                            result.installation.instAddr3 +" "+
                            result.installation.instPostCode +" "+
                            result.installation.instArea+" "+ 
                            result.installation.instState +" "+ 
                            result.installation. instCnty;
                        
    $("#address").html(address);
    
    $("#installNo").html(result.installation.lastInstallNo);
    $("#installDate").html(result.installation.lastInstallDt);
    
    
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
    
    $("#TO_YYYYMM").val( result.srvconfig.add12todate);
    $("#EX_YYYYMM").val( result.srvconfig.add12expiredate);
    
    $("#expire").html( result.srvconfig.lastSrvMemExprDate);
    
    
    fn_newGetExpDate(result);
    fn_setTerm();
    fn_getDataCPerson();
    fn_getDatabsHistory();
    fn_getDatabsOList();
}



function  fn_goCustSearch(){
    Common.alert(" 차후 오더 조회  공통팝업 호출[미 개발] !!!  ");
}


function fn_doReset() {
    $("#sForm").attr({"target" :"_self" , "action" : "/sales/membership/mNewQuotation.do" }).submit();
}



function fn_setTerm(){
	$("#term").html();
	$("#isCharge").html();
}




function  fn_goContactPersonPop(){
    Common.popupDiv("/sales/membership/memberFreeContactPop.do");
}


function  fn_goNewContactPersonPop(){
    Common.popupDiv("/sales/membership/memberFreeNewContactPop.do");
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
  


/*bs_history*/ 
function fn_getDatabsHistory(){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_bs", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         
         AUIGrid.setGridData(bsHistoryGridID, result);
         AUIGrid.resize(bsHistoryGridID, 1120,250);  
         
    });
 }
 
 

/*newGetExpDate*/ 
function fn_newGetExpDate(old_result){
    Common.ajax("GET", "/sales/membership/newGetExpDate", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         
         if(result.expDate.expint <= 0){
        	 $("#HiddenIsCharge").val(0);
        	 $("#isCharge").html("No");
        	 $("#term").html("<font color='green'> Under membership </font>");
        	 
         }else if(result.expDate.expint > 0 && old_result.basic.coolOffPriod >= result.expDate.expint){
        	 
        	   $("#HiddenIsCharge").val(0);
               $("#isCharge").html("No");
               $("#term").html("<font color='brown'> Under cooling off period </font>");
               
         }else{
        	  $("#HiddenIsCharge").val(1);
              $("#isCharge").html("YES");
              $("#term").html("<font color='red'> Passed cooling off period </font>");
         }
         
    });
 }
 
/*oList*/ 
function fn_getDatabsOList (){
   Common.ajax("GET", "/sales/membership/newOListuotationList", $("#getDataForm").serialize(), function(result) {
        console.log( result);
        
        AUIGrid.setGridData(oListGridID, result);
        AUIGrid.resize(oListGridID, 1120,250);  
        
        if( $("#HiddenIsCharge").val() =="0"){ return ;}
        
        changeRowStyleFunction();
        
      
   });
 }
 

function setPackgCombo(){
    doGetCombo('/sales/membership/getSrvMemCode', '', '','cTPackage', 'S' , 'f_multiCombo');            // Customer Type Combo Box
}



function f_multiCombo(){
	
      $('#cTPackage').change(function() {
    	 $("#cYear").removeAttr("disabled");
    	
      });
      
      $('#cYear').change(function() {
         
    	  $("#SELPACKAGE_ID").val($('#cTPackage').val());
    	  $("#DUR").val($(this).val().trim());
    	  
    	  fn_getMembershipPackageInfo();
    	  
    	  
    	  
    	  /*
    	  //
          this.LoadMembershipPackage(StkID, PackageID, Duration);
          
          
          
          if (HiddenHasFilterCharge.Value == "1")
          {
              this.LoadMembershipFilter(OrdeID, 0);
              this.LoadMembershipPromotion(PackageID, StkID);
              btnViewFilterCharge.Visible = true;
          }
          else
          {
              txtFilterCharge.Text = "0.00";
          }
          cbPromoPac.Enabled = true;
          
          */
      });
}




/*fn_getMembershipPackageInfo*/ 
function fn_getMembershipPackageInfo(){
    Common.ajax("GET", "/sales/membership/mPackageInfo", $("#getDataForm").serialize(), function(result) {
         console.log( result);
         
         
         if( result.packageInfo ==null  ||  result.packageInfo ==""){

        	 $("#HiddenHasPackage").val(0);
             $("#txtBSFreq").html("");
             $("#txtPackagePrice").html("0.00");
             $("#hiddenPacOriPrice").val(0);
             
             /*
             $("#HiddenHasPackage").val(0)
             txtPackagePrice.Text = "0.00";
             hiddenPacOriPrice.Value = "0";
             */
             
             
         }else{
        	 
              var   pacYear   =  parseInt($("#DUR").val() ,10) / 12;
              var   pacPrice =  Math.round((result.packageInfo.srvMemItmPrc * pacYear));
              
             
        	   $("#HiddenHasPackage").val(1);
        	   $("#txtBSFreq").html(result.packageInfo.srvMemItmPriod +" month(s)");
        	   $("#txtPackagePrice").html(pacPrice);
        	   $("#hiddenPacOriPrice").val(pacPrice);
        	   
        	   
        	  
        	 /*
             HiddenHasPackage.Value = "1";
             txtBSFreq.Text = pi.BSFreq.ToString() + " month(s)";
             double pacPrice = pi.PacPrice * pacYear;
             pacPrice = Math.Round(pacPrice, 0, MidpointRounding.AwayFromZero);
             txtPackagePrice.Text = string.Format("{0:0.00}", pacPrice.ToString());
             hiddenPacOriPrice.Value = pacPrice.ToString();
             */
         }
         
         
         if ( $("#HiddenHasFilterCharge") .val() == "1") {
        	 fn_LoadMembershipFilter();
        	 fn_LoadMembershipPromotion();
             $("#btnViewFilterCharge").attr("style" ,"display:inline");
        	 
         } else{
        	 $("#txtFilterCharge").html("0.00");
         }
         
         $("#packpro").removeAttr("disabled");
         
    });
 }
 
 
 
function fn_doPackagePro(v){
   if(v.checked){
	}
}


function fn_LoadMembershipPromotion(){
	doGetCombo('/sales/membership/getPromotionCode', '', '','cPromotion', 'S' , 'f_multiCombo');            // Customer Type Combo Box
	$("#cPromotion").removeAttr("disabled");
	
	/*
	   
private void LoadMembershipPromotion(int PackageID,int StkID)
{
    ddlPromotion.Items.Clear();
    MembershipManager mm = new MembershipManager();
    List<MembershipPromotionInfo> ls = mm.GetMembershipPromotion(PackageID, StkID);
    if (ls.Count > 0)
    {
        cbPromo.Enabled = true;
        ddlPromotion.DataTextField = "PromoCodeName";
        ddlPromotion.DataValueField = "PromoID";
        ddlPromotion.DataSource = ls;
        ddlPromotion.DataBind();
        ddlPromotion.ClearSelection();
        ddlPromotion.Text = string.Empty;
    }

    //Ben - 2016/09/30 - Validate eligibility for Early Bird Promotion
    MembershipManager oo = new MembershipManager();
    
}
	
	*/
}


 
 
 function   fn_LoadMembershipFilter(){
	 
	 Common.popupDiv("/sales/membership/mFilterChargePop.do");
	 
	 
	 
	 /*

	 private void LoadMembershipFilter(int OrderID,int PromoID)
	 {
	     MembershipManager mm = new MembershipManager();
	     List<Data.spGetOrderMembershipFilterChargeAmount_Result> ls = mm.GetMembershipFilterChargeList(OrderID, PromoID);
	     if (ls.Count > 0)
	     {
	         RadGrid_FilterCharge.DataSource = ls;
	         RadGrid_FilterCharge.DataBind();
	         GridFooterItem footer = (GridFooterItem)RadGrid_FilterCharge.MasterTableView.GetItems(GridItemType.Footer)[0];
	         string TotalPrice = footer["ChargePrice"].Text.Split(':')[1];
	         txtFilterCharge.Text = string.Format("{0:C}", TotalPrice.ToString()).Replace("$", "").Replace(",", "").Replace("RM", "");
	     }
	     else
	     {
	         txtFilterCharge.Text = "0.00";
	     }
	     if (PromoID > 0)
	     {
	         RadWindow_FilterCharge.Title = "Filter Charge Details - Promotion Applied";
	     }
	     else
	     {
	         RadWindow_FilterCharge.Title = "Filter Charge Details - No Promotion";
	     }
	 }
	 
	 */
 }
 
 



function changeRowStyleFunction() {
	
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(oListGridID, "rowStyleFunction", function(rowIndex, item) {
    	

        var  lifePeriod = parseInt(item.srvFilterPriod ,10);
        var expInt     = parseInt(item.expint ,10);
         
        if (lifePeriod > 0){
        	
            if(expInt > lifePeriod  ){
            	
                  $("#HiddenHasFilterCharge").val(1);
                  return "my-row-style";
                  
            }else{
            	return "";
            }
            
            /*
             DateTime LastChangeDate = CommonFunction.ConvertDateDMYToMDY(item["FilterLastChange"].Text.Trim());
             DateTime todayDate = CommonFunction.GetFirstDayOfMonth(DateTime.Now.Date);
             
             int expireDateInt = (LastChangeDate.Year * 12) + LastChangeDate.Month;
             int todayDateInt = (todayDate.Year * 12) + todayDate.Month;
             int expInt = todayDateInt - expireDateInt;
             if (expInt > lifePeriod)
             {
                 e.Item.BackColor = System.Drawing.Color.Pink;
                 HiddenField hf = (HiddenField)item.FindControl("HiddenFilterCharge");
                 hf.Value = "1";
                 HiddenHasFilterCharge.Value = "1";
             }
             */
        
        }   
    });
    
    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(oListGridID);
};




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
        selectionMode       : "singleRow",  //"multipleCells",    
        showRowNumColumn    : true         //줄번호 칼럼 렌더러 출력    
       
    };
    
    bsHistoryGridID = GridCommon.createAUIGrid("hList_grid_wrap", columnLayout, "", gridPros);
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
                               width          : "50%",                
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
        showRowNumColumn    : true,
        
        
        // row Styling 함수
        rowStyleFunction : function(rowIndex, item) {
         
            return "";
        }
    };
    
    oListGridID = GridCommon.createAUIGrid("oList_grid_wrap", columnLayout, "", gridPros);
}


</script>



<form id="getDataForm" method="post">
<div style="display:inline">
    <input type="text" name="ORD_ID"     id="ORD_ID"/>  
    <input type="text" name="CUST_ID"    id="CUST_ID"/>  
    <input type="text" name="IS_EXPIRE"  id="IS_EXPIRE"/>   <!--  1: EXPIRE  -->
    <input type="text" name="STOCK_ID"  id="STOCK_ID"/>  
    <input type="text" name="PAC_ID"  id="PAC_ID"/>  
    <input type="text" name="TO_YYYYMM"  id="TO_YYYYMM" />  
    <input type="text" name="EX_YYYYMM"  id="EX_YYYYMM"/>  
    
    
    <!--Type of Package  -->
    <input type="text" name="SELPACKAGE_ID"  id="SELPACKAGE_ID"/>  
    <!--Subscription Year  -->
    <input type="text" name="DUR"  id="DUR"/>  
          
          
    
    
</div>
</form>

<form id="oListDataHiddenForm" method="post">
<div style="display:inline">
    <input type="text" name="HiddenHasFilterCharge"  id="HiddenHasFilterCharge"/>  
    <input type="text" name="HiddenIsCharge"  id="HiddenIsCharge"/>  
    <input type="text" name="HiddenHasPackage"  id="HiddenHasPackage"/> 
    <input type="text" name="hiddenPacOriPrice"  id="hiddenPacOriPrice"/> 
    
</div>
</form>



<div id="popup_wrap" class="popup_wrap  pop_win"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Management -Quotation New  </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<section id="content"><!-- content start -->


<section class="search_table"><!-- search_table start -->
<form action="#"   id="sForm"  name="sForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Order No</th>
	<td>
	       <input type="text" title="" id="ORD_NO" name="ORD_NO" placeholder="" class="" /><p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> Confirm</a></p>   <p class="btn_sky" id='sbt'><a href="#" onclick="javascript: fn_goCustSearch()">Search</a></p>
           <input type="text" title="" id="ORD_NO_RESULT" name="ORD_NO_RESULT"   placeholder="" class="readonly " readonly="readonly" /><p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()">Reselect</a></p>
 	</td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->


<div  id="resultcontens"  style="display:none">

		
		<section class="tap_wrap"><!-- tap_wrap start -->
		<ul class="tap_type1">
		    <li><a href="#" class="on">Order Info</a></li>
		    <li><a href="#">Contact Person</a></li>
		    <li><a href="#">BS History</a></li>
		    <li><a href="#">Order Product Filter</a></li>
		</ul>
		
		<article class="tap_area"><!-- tap_area start -->
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:180px" />
		    <col style="width:*" />
		    <col style="width:180px" />
		    <col style="width:*" />
		    <col style="width:180px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Order No</th>
		    <td><span id='ordNo' ></span></td>
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
		    <td><span id='installNo'></span></td>
		</tr>
		<tr>
		    <th scope="row">Application Type</th>
		    <td><span id='appTypeDesc'></span></td>
		    <th scope="row">Reference No</th>
		    <td><span id='ordRefNo'></span></td>
		    <th scope="row">Install Date</th>
		    <td><span id='installDate'></span></td>
		</tr>
		<tr>
		    <th scope="row">Stock Code</th>
		    <td><span id='stockCode'></span></td>
		    <th scope="row">Stock Name</th>
		    <td colspan="3" id='stockDesc'><span></span></td>
		</tr>
		<tr>
		    <th scope="row">Cooling Off Period</th>
		    <td><span id='coolingOffPeriod'>text</span></td>
		    <th scope="row">Term</th>
		    <td><span id='term'></span></td>
		    <th scope="row">Is Charge</th>
		    <td><span id='isCharge'></span></td>
		</tr>
		<tr>
		    <th scope="row" rowspan="3">Instalation Address</th>
		    <td rowspan="3" colspan="3" id='address'><span></span></td>
		    <th scope="row">Order Outstanding</th>
		    <td><span id='ordoutstanding'></span></td>
		</tr>
		<tr>
		    <th scope="row">AS Outstanding</th>
		    <td><span id='asoutstanding'></span></td>
		</tr>
		<tr>
		    <th scope="row">Membership Expire</th>
		    <td><span id='expire'></span></td>
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
		    <td colspan="5" id='custNric' ><span></span></td>
		</tr>
		</tbody>
		</table><!-- table end -->
		<p class="brown_text mt10">(Is Charge = Yes : Filter service charges is depends on the filter expiration date)</p>
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
		    <col style="width:180px" />
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
		   <div id="hList_grid_wrap" style="width:100%; height:400px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
       </article><!-- tap_area end -->
		
		
		
		<article class="tap_area"><!-- tap_area start -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		   <div id="oList_grid_wrap" style="width:100%; height:400px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
		
		</article><!-- tap_area end -->
		
		</section><!-- tap_wrap end -->
		
		<aside class="title_line"><!-- title_line start -->
		<h3>Membership Information</h3>
		</aside><!-- title_line end -->
		
		<section class="search_table"><!-- search_table start -->
		<form action="#" method="post">
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:180px" />
		    <col style="width:*" />
		    <col style="width:150px" />
		    <col style="width:100px" />
		    <col style="width:100px" />
            <col style="width:100px" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Type of Package</th>
		    <td>
		    <select class="w100p" id='cTPackage' name='cTPackage'></select>
		    </td>
		    <th scope="row">Subscription Year</th>
		    <td width='80px'>
		    <select  id="cYear"   style="width:80px"  disabled="disabled"  >
		        <option value="12" >1</option>
		        <option value="24">2</option>
		        <option value="36">3</option>
		        <option value="48">4</option>
		    </select>
		    </td>
		    
		      <th scope="row">Employee </th>
	            <td>
	            <select  style="width:80px"  id="cEmplo" >
	                <option value="Y">Y</option>
	                <option value="N">N</option>
	            </select>
	            </td>
	            
	            
		</tr>
		<tr>
		    <th scope="row">Package Promotion</th>
		    <td>
		    <label><input type="checkbox" disabled="disabled"  id="packpro"   name="packpro" onclick="fn_doPackagePro(this)" /><span></span></label>
		            <select class="disabled" disabled="disabled"  id="cPromotion" name="cPromotion" > </select>
		    </td>
		    <th scope="row">Package Price</th>
		    <td  colspan="3"><span id='txtPackagePrice'>text</span></td>
		</tr>
		<tr>
		    <th scope="row">Filter Promotion</th>
		    <td>
		    <select class="disabled w100p" disabled="disabled">
		        <option value="">11</option>
		        <option value="">22</option>
		        <option value="">33</option>
		    </select>
		    </td>
		    <th scope="row">Filter Price</th>
		    <td colspan="3">
		      <span id="txtFilterCharge">text</span>
		      <div  id="btnViewFilterCharge"  style="display:none">  <p class="btn_sky"><a href="#">Detail</a></p> </div>
		    </td>
		</tr>
		<tr>
		    <th scope="row">Sales Person Code</th>
		    <td><input type="text" title="" placeholder="" class="" style="width:140px;" /><p class="btn_sky"><a href="#">Cofirm</a></p><p class="btn_sky"><a href="#">Search</a></p></td>
		    <th scope="row">Sales Person Name</th>
		    <td colspan="3"><span>text</span></td>
		</tr>
		<tr>
		    <th scope="row">Remark</th>
		    <td><textarea cols="20" rows="5"></textarea></td>
		    <th scope="row">BS Frequency</th>
		    <td colspan="3" ><span id='txtBSFreq'>text</span></td>
		</tr>
		</tbody>
		</table><!-- table end -->
		</form>
		</section><!-- search_table end -->
		

		<ul class="center_btns">
		    <li><p class="btn_blue2"><a href="#">Save</a></p></li>
		    <li><p class="btn_blue2"><a href="#">Back</a></p></li>
		</ul>

</div>
</section><!-- content end -->


</section>
</div>

