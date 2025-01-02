<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
   .aui-grid-template-renderer-wrapper {
       height:auto !important;
       text-align:left;
    }

   .my-yellow-style {
	    background:#fbffc0;
	    color:#22741C;
   }

	.my-green-style {
	    background:#86E57F;
	    color:#22741C;
	}
</style>
<script type="text/javaScript">
  let option = {
	    width : "1200px",
	    height : "500px"
  };

  let optionSystem = {
        type: "M",
        isShowChoose: false
  };

  let myGridID;

  let gridPros = {
	       usePaging: true,
	        pageRowCount: 20,
	        editable: false,
	        headerHeight: 60,
	        showRowNumColumn: true,
	        wordWrap: true,
	        showStateColumn: false

  };

  let columnLayout = [
     {
	    dataField : "custId",
	    headerText : "Customer ID",
	    editable : false,
	    visible: false
     },
     {
	    dataField : "name",
	    headerText : "Customer Name",
	    editable : false,
	    width : "25%"
     },
     {
	    dataField : "custType",
	    headerText : "Customer Type",
	    editable : false,
	    width : "25%"
     },
     {
	    dataField : "ccpRem",
	    headerText : "CCP Remark",
	    editable : false,
	    width : "25%",
	    style : "aui-grid-left-column",
	    renderer : {
                   type : "TemplateRenderer",
        },
        labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
            let v = value.replace(/\n/g, '<br/>');
            return v;
        }
     },
//      {
//         dataField : "custMonth",
//         headerText : "Cust ID Month",
//         editable : false,
//         width : "10%"
//      },
//      {
//         dataField : "custId",
//         headerText : "Customer ID",
//         editable : false,
//         width : "10%",
//         visible: false
//      },
//      {
//         dataField : "chsStatus",
//         headerText : "CHS Status",
//         editable : false,
//         width : "10%"
//      },
//      {
//          dataField : "chsRsn",
//          headerText : "CHS Reason",
//          editable : false,
//          width : "10%"
//      },
//      {
//     	 dataField : "appvReq",
//          headerText : "New Sales Approval Requirements",
//          editable : false,
//          width : "50%",
//          renderer: {
//              type: "TemplateRenderer"
//          },
//          labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
//              return value;
//          }
//       },
  ];

  $(document).ready(function() {
	    preCcpGrid();
	    displayOrder(2);

	    AUIGrid.bind(myGridID, "cellDoubleClick", function( event ) {
	    	console.log("custId : " + event.item.custId);
	    	Common.popupDiv("/sales/ccp/preCcpResultInfo.do", {custId: event.item.custId}, null, true, '');
	    });
  });

//   $(function(){
// 	     preCcpGrid();

//          $('#orderDetails').click(function (e){
//             Common.popupDiv("/sales/ccp/preCcpOrderSummary.do", {custId: $("#saveCustId").val()}, null, true, '');
//          });

//   });

  function displayOrder(type){
	  if(type==1){
		  $("#orderDetails").show();
	  }
	  else{
		  $("#orderDetails").hide();
	  }
  }

  function preCcpGrid() {
      $("#grid_wrap_preCcpList .aui-grid").remove()
      myGridID = AUIGrid.create("#grid_wrap_preCcpList", columnLayout, gridPros);

//       AUIGrid.bind(myGridID, "cellDoubleClick", function( event ) {
//     	  if(event.item.chsStatus == "YELLOW"){
//     		  Common.popupDiv("/sales/ccp/preCcpOrderSummary.do", {custId: event.item.custId}, null, true, '');
//     	  }
//     });
  }

  function checkPreCcpResult(){
	  $("#saveCustId").val("");
	  if (validateUpdForm()){
		  Common.ajax("GET", "/sales/ccp/checkPreCcpResult.do", $("#preCcpResultForm").serialize(), function(result) {
// 	          preCcpGrid();
	          if(result != null){
	        	  if(result.chsStatus == "-"){
	        		  Common.alert("1. Record Not Found For This Existing Customer");
	        	  }
	        	  AUIGrid.setGridData(myGridID, result);
// 	              AUIGrid.setProp(myGridID, "rowStyleFunction", function() {
//                        if(result.chsStatus == "GREEN"){
//                     	   displayOrder(1);
//                     	   $("#saveCustId").val("");
//                            return "my-green-style";
//                        }
//                        else if(result.chsStatus == "YELLOW"){
//                     	   displayOrder(1);
//                     	   $("#saveCustId").val(result.custId);
//                            return "my-yellow-style";
//                        }
//                        else{
//                     	   displayOrder(2);
//                     	   $("#saveCustId").val("");
//                     	   return "";
//                        }
// 	              });
	              AUIGrid.update(myGridID);
	          }
	          else{
	        	  displayOrder(2);
// 	              Common.alert("Record Not Found. Please proceed to check Pre-CCP in New Customer module.");
	              Common.alert("<span style='color:red;'>Notice: The record was not found. Please reconfirm the NRIC or Customer ID or click \"New Customer\" to proceed with the Pre-CCP check for new customers.</span>");
	          }
	      });
	  }
  }

  function validateUpdForm() {
	  if (FormUtil.isEmpty($("#customerNric").val()) && FormUtil.isEmpty($("#customerId").val())) {
          Common.alert("Please key in Customer NRIC or Customer ID.");
          return false;
      }
//       else{
//           if(!checkAge()){
//                 Common.alert("This customer is not allowed to check Pre-CCP.");
//                 return false;
//           }
//       }
	  return true;
  }

  function checkAge() {
      let dob = $("#customerNric").val().substring(0, 2);
      let dobYear = (dob >=50 ? '19' : '20') + dob ;
      let ageValid =  (new Date()).getFullYear() - dobYear;

      if(ageValid < 18 || ageValid > 70){
          return false;
      }

      return true;
 }

  function fn_reload(){
      location.reload();
  }

  function fn_preCcpEditRemark(){
      Common.popupDiv("/sales/ccp/preCcpEditRemark.do", {}, null, true);
  }

  function clearForm(formId){
      document.getElementById(formId).reset();
      AUIGrid.clearGridData(myGridID);

  }

</script>

<section id="content">

  <ul class="path"></ul>
  <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p><h2>Pre-CCP Result</h2>

		<ul class="right_btns">
			    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
			          <li><p class="btn_blue"><a href="javascript:void(0);" onclick="fn_preCcpEditRemark()">Edit Remark</a></p></li>
			    </c:if>

			   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
			        <li><p class="btn_blue"><a href="javascript:void(0);" onClick="checkPreCcpResult()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			   </c:if>

		        <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:$('#preCcpResultForm').clearForm();"><span class="clear"></span><spring:message code='service.btn.Clear'/></a></p></li>
		</ul>
 </aside>

 <section class="search_table">
		<form action="#" method="post" id="preCcpResultForm">
				<table class="type1">
				        <colgroup>
				             <col style="width: 200px" />
				             <col style="width: *" />
				             <col style="width: 140px" />
				             <col style="width: *" />
				        </colgroup>
				        <tbody>
	                         <tr>
	                             <th scope="row">NRIC</th>
	                             <td><input type="text" title="" placeholder="NRIC" class="w100p" id="customerNric" name="customerNric" maxlength=12/></td>

	                             <th scope="row">Customer ID</th>
	                             <td><input type="text" title="" placeholder="customer ID" class="w100p" id="customerId" name="customerId" maxlength=12/></td>
	                         </tr>
                        </tbody>
				</table>
				<br/>
                <div id="orderDetails">Click in to view order list</div>
                <input type="hidden" id="saveCustId">
			    <article class="grid_wrap">
			         <div id="grid_wrap_preCcpList" style="width: 100%; margin: 0 auto;"></div>
			    </article>
		</form>
</section>
</section>

