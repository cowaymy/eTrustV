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
    $("#FREE_ORD_NO_RESULT").attr("style","display:none");

});



function setPackgCombo(){
	doGetCombo('/sales/membership/selectMembershipFree_Packg', '', '','cTPackage', 'S' , 'f_multiCombo');            // Customer Type Combo Box
}


function f_multiCombo(){

	$('#cTPackage').change(function() {
		$("#FREE_PAC_ID").val($(this).val());

		console.log(this)
	    Common.ajax("GET", "/sales/membership/selectMembershipFree_PChange", $("#getDataForm").serialize(), function(result) {

		    	console.log(result);
		    	if(result.length > 0){
		    		   $("#bsFreq").html (result[0].srvMemItmPriod+" month(s)");
		    		   $("#duration").html (result[0].c1+" month(s)");
		    		   $("#FREE_TOYYMM").val (result[0].toyymm);


		    	}else{
		    		 $("#bsFreq").html ("");
                     $("#duration").html ("");
                     $("#toyymm").html ("");
		    	     Common.alert("  <spring:message code="sal.alert.msg.packageInfoNotFound" /> ");
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
			 $("#FREE_ORD_NO").attr("style","display:inline");
			 $("#sbt").attr("style","display:inline");


			 $("#rbt").attr("style","display:none");
			 $("#FREE_ORD_NO_RESULT").attr("style","display:none");

			 $("#resultcontens").attr("style","display:none");

             Common.alert(" <spring:message code="sal.alert.msg.noOrderFound" /> ");
             return ;

		 }else{

			 $("#FREE_ORD_ID").val( result[0].ordId);
			 $("#FREE_ORD_NO_RESULT").val( result[0].ordNo);


		     $("#cbt").attr("style","display:none");
             $("#FREE_ORD_NO").attr("style","display:none");
             $("#sbt").attr("style","display:none");



             $("#rbt").attr("style","display:inline");
             $("#FREE_ORD_NO_RESULT").attr("style","display:inline");
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
		$("#FREE_SAVE_CUST_CNTC_ID").val(result[0].custCntcId);


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
     $("#FREE_SAVE_CUST_CNTC_ID").val("");
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
    Common.popupDiv('/sales/ccp/searchOrderNoPop.do' , {pdpaMonth:${pdpaMonth}}, null , true, '_searchDiv');
}


function fn_callbackOrdSearchFunciton(item){
    console.log(item);
    $("#FREE_ORD_NO").val(item.ordNo);
    fn_doConfirm();

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

            $("#FREE_CUST_ID").val( result.basic.custId);
            $("#FREE_STOCK_ID").val( result.basic.stockId);
            $("#FREE_SAVE_SRV_CONFIG_ID").val(result.srvconfig.configId);

            if(result.srvconfig.exprtext =="Expired"){
            	 $("#expire").html( "<font color='Red'>"+result.srvconfig.exprtext+"</font>");
            	 $("#FREE_IS_EXPIRE").val("1");
            }else{
            	 $("#expire").html( result.srvconfig.exprtext);
            	 $("#FREE_IS_EXPIRE").val("0");
            }

/* 	        var address  =  result.installation.instAddr1 +" "+
						            result.installation.instAddr2 +" "+
						            result.installation.instAddr3 +" "+
						            result.installation.instPostCode +" "+
						            result.installation.instArea+" "+
						            result.installation.instState +" "+
						            result.installation. instCnty; */


	        var address  =  result.installation.instAddrDtl +" "+
						            result.installation.instStreet +" "+
						            result.installation.instArea+" "+
						            result.installation.instPostcode +" "+
						            result.installation.instCity +" " +
						            result.installation.instState +" "+
						            result.installation.instCountry;

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
        //selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true         //줄번호 칼럼 렌더러 출력
    };

    oListGridID = GridCommon.createAUIGrid("oList_grid_wrap", columnLayout, "", gridPros);
}




function createAUIGridHList() {

    //AUIGrid 칼럼 설정
    var columnLayout = [
                        {     dataField     : "no",
                               headerText  : "<spring:message code="sal.title.bsNo" />",
                               width          : 150,
                               editable       : false
                        },
                        {     dataField     : "month",
                               headerText  : "<spring:message code="sal.title.bsMonth" />",
                               width          : 100,
                               editable       : false
                        },
                        {     dataField     : "code",
                               headerText  : "<spring:message code="sal.title.type" />",
                               width          : 100,
                               editable       : false
                        },
                        {      dataField     : "code1",
                                headerText  : "<spring:message code="sal.title.status" />",
                                width          :100,
                                editable       : false
                        },
                        {      dataField       : "no1",
                            headerText   : "<spring:message code="sal.title.bsrNo" />",
                            width           : 150,
                            editable        : false
                     },
                    {      dataField       : "c1",
                                headerText   : "<spring:message code="sal.title.settleDate" />",
                                width           : 200,
                                editable        : false
                         },
                         {      dataField       : "memCode",
                             headerText   : "<spring:message code="sal.title.codyCode" />",
                             width           : 100,
                             editable        : false
                      },
                      {      dataField       : "code3",
                          headerText   : "<spring:message code="sal.title.failReason" />",
                          width           :100,
                          editable        : false
                   },
                   {      dataField       : "code2",
                       headerText   : "<spring:message code="sal.title.collectionReason" />",
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
//        selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true         //줄번호 칼럼 렌더러 출력
    };

    bsHistoryGridID = GridCommon.createAUIGrid("hList_grid_wrap", columnLayout, "", gridPros);
}


function fn_doReset() {
   // window.close();

    $("#cbt").attr("style","display:inline");
    $("#FREE_ORD_NO").attr("style","display:inline");
    $("#sbt").attr("style","display:inline");


    $("#rbt").attr("style","display:none");
    $("#FREE_ORD_NO_RESULT").attr("style","display:none");

    $("#resultcontens").attr("style","display:none");
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
          $("#FREE_SAVE_CUST_CNTC_ID").val(objInfo.custCntcId);


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

				    $("#FREE_SAVE_ORD_ID").val($("#FREE_ORD_ID").val());
				    $("#FREE_SAVE_PAC_ID").val($("#FREE_PAC_ID").val());
				    $("#FREE_SAVE_BS_FREQ").val(($("#bsFreq").text()).replace(" <spring:message code="sales.month" />",""));

				    aList = $("#mypStartDate").val().split("/");

				    $("#FREE_SAVE_START_DATE").val(aList[1]+"-"+aList[0]+"");
				    $("#FREE_SAVE_DURATION").val(($("#duration").text()).replace(" <spring:message code="sales.month" />",""));

				    Common.ajax("GET", "/sales/membership/selectMembershipFree_save", $("#saveForm").serialize(), function(result) {

	                    var resultFalge = false;
				    	if(result.resultIntKey  != "0" ) resultFalge=true;


					    if(resultFalge){
					    	Common.alert("<b><spring:message code="sal.alert.msg.freeMemSuccess" /></b>");
					    	fn_doConfirm ();

					    }else {
					    	Common.alert(" <b><spring:message code="sal.alert.msg.freeMemFail" /></b>");
					    }
				   });


			 }else{
				   if(  $("#FREE_IS_EXPIRE").val() == 0){
							 Common.alert(" <b><spring:message code="sal.alert.msg.invalidStartDate" /></b>");
							 return ;
					}else{
							 Common.alert(" <b><spring:message code="sal.alert.msg.invalidStartDate2" /></b>");
							 return ;
					}
			 }
	}
}


function fn_validReqField(){

	 if($("#cTPackage").val() =="") {

		 var arg = "<spring:message code="sal.text.typeOfPack" />";
		 Common.alert("<spring:message code="sal.alert.msg.requiredField" arguments='"+arg+"' htmlEscape='false'/>");
		 return false;
	 }

	 if($("#mypStartDate").val() =="") {

		 var arg="<spring:message code="sal.text.startDate" />";
         Common.alert("<spring:message code="sal.alert.msg.requiredField" arguments='"+arg+"' htmlEscape='false'/>");
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
	var compareDate  = $("#FREE_TOYYMM").val();
	var  selectedDate = ($("#mypStartDate").val());


    aList = selectedDate.split("/");
    selectedDate=aList[1]+""+aList[0];

    console.log("compareDate["+compareDate+"]selectedDate["+selectedDate+"]IS_EXPIRE["+$("#FREE_IS_EXPIRE").val()+"]");


	if(  $("#FREE_IS_EXPIRE").val() == 0){
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


/* function fn_close(){

	window.close();
} */

</script>



<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.freeMem" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_close()"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->




<section id="content"><!-- content start -->



<form id="getDataForm" method="post">
<div style="display:none">
    <input type="text" name="ORD_ID"     id="FREE_ORD_ID"/>
    <input type="text" name="CUST_ID"    id="FREE_CUST_ID"/>
    <input type="text" name="IS_EXPIRE"  id="FREE_IS_EXPIRE"/>   <!--  1: EXPIRE  -->
    <input type="text" name="STOCK_ID"  id="FREE_STOCK_ID"/>
    <input type="text" name="PAC_ID"  id="FREE_PAC_ID"/>
    <input type="text" name="TOYYMM"  id="FREE_TOYYMM"/>
</div>
</form>




<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.page.subTitle.selectOrder" /></h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="sForm"  name="sForm" method="post">
<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${pdpaMonth}'/>
<input id="isHc" name="isHc" type="hidden" value='1'/>



<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr >
    <th scope="row"  ><spring:message code="sal.text.ordNo" /></th>
    <td >

          <input type="text" title="" id="FREE_ORD_NO" name="ORD_NO" placeholder="" class="" /><p class="btn_sky"  id='cbt'> <a href="#" onclick="javascript: fn_doConfirm()"> <spring:message code="sal.btn.confirm" /></a></p>   <p class="btn_sky" id='sbt'><a href="#" onclick="javascript: fn_goCustSearch()"><spring:message code="sal.btn.search" /></a></p>
          <input type="text" title="" id="FREE_ORD_NO_RESULT" name="ORD_NO_RESULT"   placeholder="" class="readonly " readonly="readonly" /><p class="btn_sky" id="rbt"> <a href="#" onclick="javascript :fn_doReset()"><spring:message code="sal.btn.reselect" /></a></p>

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
    <!--  <li><a href="#" class="on">Membership Info</a></li> -->
	<li><a href="#"   class="on" id='orderTab' onclick=" javascript:AUIGrid.resize(oListGridID, 1120,300);" ><spring:message code="sal.tap.title.ordInfo" /></a></li>
	<li><a href="#"><spring:message code="sal.tap.title.contactPerson" /></a></li>
	<li><a href="#" onclick="javascript:AUIGrid.resize(bsHistoryGridID, 1120,400); " ><spring:message code="sal.tap.title.bsHis" /></a></li>

</ul>






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
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><span id="ordNo"></span></td>
    <th scope="row"><spring:message code="sales.ordDt" /></th>
    <td><span id='ordDt'></span></td>
    <th scope="row"><spring:message code="sal.text.insPeriod" /></th>
    <td><span id='InstallmentPeriod'></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.ordStus" /></th>
    <td><span id='ordStusName'></span></td>
    <th scope="row"><spring:message code="sales.RentalStatus" /></th>
    <td><span id='rentalStus'></span></td>
    <th scope="row"><spring:message code="sal.text.insNo" /></th>
    <td><span id='firstInstallNo'></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td><span id='appTypeDesc'></span></td>
    <th scope="row"><spring:message code="sal.text.refNo" /></th>
    <td><span id='ordRefNo'></span></td>
    <th scope="row"><spring:message code="sal.text.insDate" /></th>
    <td><span id='preferInstDt'></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.stockCode" /></th>
    <td><span id='stockCode'></span></td>
    <th scope="row"><spring:message code="sal.text.stokName" /></th>
    <td colspan="3" id='stockDesc' ><span></span></td>
</tr>
<tr>
    <th scope="row" rowspan="3"><spring:message code="sal.text.instAddr" /></th>
    <td colspan="3" rowspan="3"><span id='instalationAddress'></span></td>
    <th scope="row"><spring:message code="sal.text.ordOutstanding" /></th>
    <td><span id="ordOtstnd"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.asOutstanding" /></th>
    <td><span  id="asOtstnd"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.memExpire" /></th>
    <td><span id="expire"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span id='custId'></span></td>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td colspan="3" id='custType'><span></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td colspan="5" id='custName'><span></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" />/<spring:message code="sal.text.companyNo" /></th>
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
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_goContactPersonPop()"><spring:message code="sal.btn.otherContactPerson" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_goNewContactPersonPop()"><spring:message code="sal.btn.newContactPerson" /></a></p></li>
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
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td colspan="5" id="name"><span></span></td>
    <th scope="row"></th>
    <td><span id="gender"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td colspan="5" id="nric"><span></span></td>
    <th scope="row"><spring:message code="sal.title.race" /></th>
    <td><span id="codename1"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.mobileNo" /></th>
    <td><span id="telM1"></span></td>
    <th scope="row"><spring:message code="sal.text.officeNo" /></th>
    <td><span id="telO"></span></td>
    <th scope="row"><spring:message code="sal.text.residenceNo" /></th>
    <td><span id="telR" ></span></td>
    <th scope="row"><spring:message code="sal.text.faxNo" /></th>
    <td><span id="telf"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
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
<h3><spring:message code="sal.page.subTitle.freeMemInfo" /></h3>
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
	<th scope="row"><spring:message code="sal.text.typeOfPack" /></th>
	<td>
	    <select id="cTPackage" name="cTPackage" class="w100p" >
        </select>
	</td>
	<th scope="row"><spring:message code="sal.text.startDate" /></th>
	<td><input type="text"  placeholder="DD/MM/YYYY" class="j_date2 w100p"  id="mypStartDate"  name='mypStartDate'/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.membershipDuration" /></th>
	<td><span id='duration'></span></td>
	<th scope="row"><spring:message code="sal.text.bsFrequency" /></th>
	<td><span id='bsFreq'></span></td>
</tr>

<tr>
	<th scope="row"><spring:message code="sal.text.remark" /></th>
	<td colspan="3"><textarea cols="20" rows="5" id='remark'  name='remark'></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<div  style="display:none">
	<input type="text" name="SAVE_ORD_ID"  id="FREE_SAVE_ORD_ID"/>
	<input type="text" name="SAVE_PAC_ID"  id="FREE_SAVE_PAC_ID"/>
	<input type="text" name="SAVE_BS_FREQ"  id="FREE_SAVE_BS_FREQ"/>
	<input type="text" name="SAVE_START_DATE"  id="FREE_SAVE_START_DATE"/>
	<input type="text" name="SAVE_DURATION"  id="FREE_SAVE_DURATION"/>
	<input type="text" name="SAVE_CUST_CNTC_ID"  id="FREE_SAVE_CUST_CNTC_ID"/>
	<input type="text" name="SAVE_SRV_CONFIG_ID"  id="FREE_SAVE_SRV_CONFIG_ID"/>
</div>

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_doSave()"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- content end -->

</section>

</section>
</div>

<script>

</script>