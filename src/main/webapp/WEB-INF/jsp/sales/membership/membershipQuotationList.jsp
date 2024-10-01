<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>




<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var  gridID;

    $(document).ready(function(){
        $("#table1").hide();

        if("${SESSION_INFO.userTypeId}" == "1" ||"${SESSION_INFO.userTypeId}" == "2" ){
            $("#table1").show();
        }

        if("${SESSION_INFO.memberLevel}" =="1"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="2"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="3"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="4"){

            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}");
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");

            $("#memCode").val("${memCode}");
            $("#memCode").attr("class", "w100p readonly");
            $("#memCode").attr("readonly", "readonly");
        }

        createAUIGrid();

        $("#btnDeactive").hide();

        AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
            console.log(event.rowIndex);
            fn_doViewQuotation();
        });

        AUIGrid.bind(gridID, "cellClick", function(event) {
            console.log(event.rowIndex);

            if(AUIGrid.getCellValue(gridID, event.rowIndex, "validStus") == "ACT"){
                $("#deActQuotNo").val(AUIGrid.getCellValue(gridID, event.rowIndex, "quotNo") );
                $("#deActOrdNo").val(AUIGrid.getCellValue(gridID, event.rowIndex, "ordNo") );
                $("#btnDeactive").show();
            }else{
                $("#deActQuotNo").val("");
                $("#deActOrdNo").val("");
                $("#btnDeactive").hide();
            }
        });

        var optionUnit = {
        		id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
                name: "codeName",  // 콤보박스 text 에 지정할 필드명.
        		isShowChoose: false,
        		isCheckAll : false,
        		type : 'M'
        };

        var selectValue = "1" + DEFAULT_DELIMITER + "81";

        CommonCombo.make('VALID_STUS_ID', "/status/selectStatusCategoryCdList.do", {selCategoryId : 22} , selectValue , optionUnit);

    });


    // 리스트 조회.
   function fn_selectListAjax() {


	   AUIGrid.refreshRows() ;
    	if( $("#QUOT_NO").val() ==""  &&  $("#L_ORD_NO").val() ==""  &&  $("#CRT_SDT").val() ==""  ){
    	 Common.alert("<spring:message code="sal.alert.msg.keyInMemNoOrdNoCrtDt" />");
    		return ;
    	}

   	   if($("#CRT_EDT").val() !=""){
   	        if($("#CRT_SDT").val()==""){
   	             var msg = '<spring:message code="sales.CreateDate" />';
   	                Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
   	                    $("#CRT_SDT").focus();
   	                });
   	                return;
   	        }else{

   	        	var st = $("#CRT_SDT").val().replace(/\//g,'');
   	        	var ed = $("#CRT_EDT").val().replace(/\//g,'');

   	        	var stDate = st.substring(4,8) +""+ st.substring(2,4) +""+ st.substring(0,2);
   	        	var edDate = ed.substring(4,8) +""+ ed.substring(2,4) +""+ ed.substring(0,2);

   	            if(stDate > edDate ){
   	                 Common.alert("<spring:message code='commission.alert.dateGreaterCheck'/>", function(){
   	                     $("#CRT_EDT").focus();
   	                 });
   	                 return;
   	            }
   	        }
   	    }

       Common.ajax("GET", "/sales/membership/quotationList", $("#listSForm").serialize(), function(result) {
            console.log( result);
	        AUIGrid.setGridData(gridID, result);
       });

       $("#deActQuotNo").val("");
   }



   function createAUIGrid() {
           var columnLayout = [
                     {dataField :"quotNo",  headerText : "<spring:message code="sal.text.quotationNo" />",      width: 100 ,editable : false },
                     {dataField :"ordNo",  headerText : "<spring:message code="sal.text.ordNo" />",    width: 70, editable : false },
                     {dataField :"custName", headerText : "<spring:message code="sal.text.custName" />",   width: 140, editable : false },
                     {dataField :"validStus", headerText : "<spring:message code="sal.title.status" />",  width: 60, editable : false },
                     {dataField :"hasbill", headerText : "<spring:message code="sal.title.hasbill" />" , width: 60, editable : false ,
                         renderer : {
                             type : "CheckBoxEditRenderer",
                             editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                             checkValue : "1"
                         }
                     },
                     {dataField :"validDt", headerText : "<spring:message code="sal.title.validDate" />",width: 90, dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false },
                     {dataField :"pacDesc", headerText : "<spring:message code="sal.title.package" />", width: 140, editable : false },
                     {dataField :"dur", headerText : "<spring:message code="sal.title.durationMth" />",width: 75, editable : false },
                     {dataField :"crtDt", headerText : "<spring:message code="sal.title.crtDate" />", width: 90,  dataType : "date", formatString : "dd-mm-yyyy" ,editable : false},
                     {dataField :"crtUserId", headerText : "<spring:message code="sal.title.creator" />" , width: 120, editable : false }

          ];

           //그리드 속성 설정
         var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,
                 headerHeight        : 30,       showRowNumColumn : true};

           gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "" ,gridPros);
       }



   function  fn_doViewQuotation(){

       var selectedItems = AUIGrid.getSelectedItems(gridID);

       if(selectedItems ==""){
           Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
           return ;
       }

       /* $("#MBRSH_ID").val(selectedItems[0].item.memId); */
       $("#MBRSH_ID").val(selectedItems[0].item.cnvrMemId);
       $("#QUOT_ID").val(selectedItems[0].item.quotId);
      /*  var pram  ="?QUOT_ID="+selectedItems[0].item.quotId+"&ORD_ID="+selectedItems[0].item.ordId+"&CNT_ID="+selectedItems[0].item.cntId +"&MBRSH_ID="+selectedItems[0].item.memId; */
       var pram  ="?QUOT_ID="+selectedItems[0].item.quotId+"&ORD_ID="+selectedItems[0].item.ordId+"&CNT_ID="+selectedItems[0].item.cntId +"&MBRSH_ID="+selectedItems[0].item.cnvrMemId;
       console.log("aziamh" + pram);
       Common.popupDiv("/sales/membership/mViewQuotation.do"+pram ,null, null , true , '_ViewQuotDiv1');
 }


 function  fn_goNewQuotation(){
	    Common.popupDiv("/sales/membership/mNewQuotation.do" ,$("#listSForm").serialize(), null , true , '_NewQuotDiv1');
 }

 function  fn_goQuotationRawData(){
	  Common.popupDiv("/sales/membership/mQuotationRawData.do");
// 	  Common.popupDiv("/homecare/services/install/report/installationRawDataPop.do", null, null, true, '');
}


 function fn_editQuotation() {
	 var selectedItems = AUIGrid.getSelectedItems(gridID);

     if(selectedItems ==""){
         Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
         return ;
     }

 }



function fn_goConvertSale(){

   var selectedItems = AUIGrid.getSelectedItems(gridID);

   if(selectedItems ==""){
       Common.alert("<spring:message code="sal.alert.noQuotationSelected" />");
       return ;
   }

   var v_stus = selectedItems[0].item.validStus;
   if(v_stus !="ACT" ){
	   Common.alert ("<b>[" + selectedItems[0].item.quotNo + "] " + fn_getStatusActionByCode(v_stus) + ".<br /><spring:message code="sal.alert.disallowed" /></b>");
	   return;

   }else{
	   $("#QUOT_ID").val(selectedItems[0].item.quotId);
	   $("#ORD_ID").val(selectedItems[0].item.ordId);
	   $("#PAY_ORD_ID").val(selectedItems[0].item.ordId);
	   $("#MBRSH_ID").val(selectedItems[0].item.cnvrMemId);


	   var pram  ="?QUOT_ID="+selectedItems[0].item.quotId+"&ORD_ID="+selectedItems[0].item.ordId +"&MBRSH_ID="+selectedItems[0].item.cnvrMemId;
	   Common.popupDiv("/sales/membership/mConvSale.do"+pram,null, null , true , '_mConvSaleDiv1');

   }
 }



function fn_getStatusActionByCode(code){

	if( code =="CON"){
		return "<spring:message code="sal.text.convToSales" />";
	}else if(code =="DEA"){
		return "<spring:message code="sal.text.deactivated" />";
	}else if(code =="EXP"){
        return "<spring:message code="sal.text.expired" />";
    }else{
    	return "";
    }
}


function fn_clear(){

	$("#CRT_USER_ID").val("");
	$("#CRT_EDT").val("");
	$("#CRT_SDT").val("");
	$("#L_ORD_NO").val("");
	$("#QUOT_NO").val("");

	$("text").each(function(){

		if($(this).hasClass("readonly")){
		}else{
			$(this).val("");
		}
	});

    $("#VALID_STUS_ID").multipleSelect("uncheckAll");

}


function fn_doPrint(){
	var selectedItems = AUIGrid.getSelectedItems(gridID);

	if(selectedItems ==""){
	       Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
	       return ;
	}


	if("1" != selectedItems[0].item.validStusId ){
		  Common.alert("Only active quotation can be generated["+selectedItems[0].item.validStusId+"]");
		return ;
	}


	// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };


    $("#V_QUOTID").val(selectedItems[0].item.quotId);

		var today = new Date(selectedItems[0].item.crtDt);
		var sstDate = new Date(2024, 3, 1); //yyyy,mm,dd -- mm need minus one

		if(today >= sstDate){
		     $("#reportFileName").val("/membership/MembershipQuotation_20240401.rpt");
		}else{

            $("#reportFileName").val("/membership/MembershipQuotation_20150401.rpt");
		}
        Common.report("reportInvoiceForm", option);
    }

    function fn_updateStus(){

    	Common.confirm("<spring:message code="sal.conf.deactivate" /> "+ $("#deActQuotNo").val() +"(orderNo." + $("#deActOrdNo").val() +")?",function(){

    			Common.ajax("GET", "/sales/membership/updateStus", $("#listSForm").serialize(), function(result) {
		            console.log( result);
		            fn_selectListAjax();

		            $("#btnDeactive").hide();
		       });
		 });

    }

 </script>




<form id="reportInvoiceForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_QUOTID" name="V_QUOTID"  value=""/>
</form>


<form id="getParamForm" method="post">

<div style="display:none">
    <input type="text" name="QUOT_ID"  id="QUOT_ID" />

    <!-- <input type="text" name="ORD_ID"  id="ORD_ID" /> -->
    <input type="text" name="MBRSH_ID"  id="MBRSH_ID" />

    <!-- Last Membership data -->
     <input type="text" name="PAY_ORD_ID"    id="PAY_ORD_ID" />
     <input type="text" name="PAY_LAST_MBRSH_ID"      id="PAY_LAST_MBRSH_ID"  />
    <!-- Last Membership data -->


</div>
</form>



<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.outrightQuotationList" /> </h2>


<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goNewQuotation()"><spring:message code="sal.btn.newQuotation" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goConvertSale()"><spring:message code="sal.btn.convertToSale" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id='listSForm' name='listSForm'>
<input type="hidden" id="deActQuotNo" name="srvMemQuotNo" />
<input type="hidden" id="deActOrdNo" name="ordNo" />
<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${PAGE_AUTH.pdpaMonth}'/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.quotationNo" />   <span class="must">*</span></th>
	<td>
	<input type="text" title="" placeholder="Quotation Number" class="w100p"  id="QUOT_NO"  name="QUOT_NO"  />

	</td>
	<th scope="row"><spring:message code="sal.text.ordNo" /> <span class="must">*</span> </th>
	<td>
	<input type="text" title="" placeholder="Order Number" class="w100p"   id="L_ORD_NO"  name="L_ORD_NO"/>
	</td>
	<th scope="row"><spring:message code="sal.title.crtDate" /> <span class="must">*</span></th>
	<td>

	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text"  placeholder="DD/MM/YYYY" class="j_date"  id="CRT_SDT"  name="CRT_SDT" /></p>
	<span><spring:message code="sal.text.to" /></span>
	<p><input type="text"  placeholder="DD/MM/YYYY" class="j_date"   id="CRT_EDT"  name="CRT_EDT"/></p>
	</div><!-- date_set end -->

	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.creator" /></th>
	<td>
	<input type="text" title="" placeholder="<spring:message code="sal.text.creator" />" class="w100p"  id="CRT_USER_ID"  name="CRT_USER_ID"/>
	</td>
	<th scope="row"><spring:message code="sal.text.status" /></th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="VALID_STUS_ID" name="VALID_STUS_ID">
	</select>
	</td>
	<th scope="row"></th>
	<td></td>
</tr>

<tr>
    <th scope="row" colspan="6" ><span class="must"> <spring:message code="sal.alert.msg.keyInMemNoOrdNoCrtDt" /></span>  </th>
</tr>

</tbody>
</table><!-- table end -->

<table class="type1"  id="table1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
    <td>
       <input type="text" title="" id="orgCode" name="orgCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
    <input type="text" title=""  id="grpCode"  name="grpCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
    <td>
    <input type="text" title=""   id="deptCode" name="deptCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td>
    <input type="text" title=""   id="memCode" name="memCode" class="w100p" />
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

	</ul>
	<ul class="btns">
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		<li><p class="link_btn"><a href="#" onclick="javascript:fn_doPrint()"><spring:message code="sal.btn.link.quotationDown" /></a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		<li><p class="link_btn"><a href="#"  onclick="javascript:fn_doViewQuotation()"><spring:message code="sal.btn.link.viewQuotation" /></a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
         <li><p class="link_btn"><a href="#" onclick="javascript:fn_goQuotationRawData()">Quotation Raw Data</a></p></li>
        </c:if>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<li><p class="btn_grid"><a href="#" id="btnDeactive" onclick="javascript:fn_updateStus()"><spring:message code="sal.btn.deactive" /></a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

