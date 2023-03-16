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
	    font-weight:bold;
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
	    dataField : "name",
	    headerText : "Customer Name",
	    editable : false,
	    width : "15%"
     },
     {
        dataField : "custMonth",
        headerText : "Cust ID Month",
        editable : false,
        width : "10%"
     },
     {
        dataField : "custId",
        headerText : "Customer ID",
        editable : false,
        width : "10%",
        visible: false
     },
     {
        dataField : "chsStatus",
        headerText : "CHS Status",
        editable : false,
        width : "10%"
     },
     {
         dataField : "chsRsn",
         headerText : "CHS Reason",
         editable : false,
         width : "10%"
     },
     {
    	 dataField : "appvReq",
         headerText : "New Sales Approval Requirements",
         editable : false,
         width : "50%",
         renderer: {
             type: "TemplateRenderer"
         },
         labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
             if (!value) return "";
             return value;
         }
      },
  ];

  $(document).ready(function() {
	    preCcpGrid();
	    displayOrder(2);
  });

  $(function(){
	     preCcpGrid();

         $('#orderDetails').click(function (e){
            Common.popupDiv("/sales/ccp/preCcpOrderSummary.do", {custId: $("#saveCustId").val()}, null, true, '');
         });

  });

  function displayOrder(type){
	  if(type==1){
		  $("#orderDetails").show();
	  }
	  else{
		  $("#orderDetails").hide();
	  }

  }

  $.fn.clearForm = function() {
      return this.each(function() {
          let type = this.type, tag = this.tagName.toLowerCase();
          if (tag === 'form'){
              return $(':input',this).clearForm();
          }
          if (type === 'text' || type === 'password'  || tag === 'textarea'){
              if($("#"+this.id).hasClass("readonly")){

              }else{
                  this.value = '';
              }
          }else if (type === 'checkbox' || type === 'radio'){
              this.checked = false;

          }else if (tag === 'select'){
              if($("#memType").val() != "7"){
                   this.selectedIndex = 0;
              }
          }
      });
  };

  function preCcpGrid() {
      $("#grid_wrap_preCcpList .aui-grid").remove()
      myGridID = AUIGrid.create("#grid_wrap_preCcpList", columnLayout, gridPros);

      AUIGrid.bind(myGridID, "cellDoubleClick", function( event ) {
    	  if(event.item.chsStatus == "YELLOW"){
    		  Common.popupDiv("/sales/ccp/preCcpOrderSummary.do", {custId: event.item.custId}, null, true, '');
    	  }
    });

  }

  function checkPreCcpResult(){
	  $("#saveCustId").val("");
	  if (validateUpdForm()){
		  Common.ajax("GET", "/sales/ccp/checkPreCcpResult.do", $("#preCcpResultForm").serialize(), function(result) {
	          preCcpGrid();
	          if(result != null){
	        	  if(result.chsStatus == "-"){
	        		  Common.alert("1. Record Not Found For This Existing Customer");
	        	  }
	        	  AUIGrid.setGridData(myGridID, result);
	              AUIGrid.setProp(myGridID, "rowStyleFunction", function() {
                       if(result.chsStatus == "GREEN"){
                    	   displayOrder(2);
                    	   $("#saveCustId").val("");
                           return "my-green-style";
                       }
                       else if(result.chsStatus == "YELLOW"){
                    	   displayOrder(1);
                    	   $("#saveCustId").val(result.custId);
                           return "my-yellow-style";
                       }
                       else{
                    	   displayOrder(2);
                    	   $("#saveCustId").val("");
                    	   return "";
                       }
	              });
	              AUIGrid.update(myGridID);
	          }
	          else{
	        	  displayOrder(2);
	        	  Common.alert("1. Record Not Found <br/>"+"2. Pre-Ccp For New Customers Is Still Under Construction");
	          }
	      });
	  }
  }

  function validateUpdForm() {
	  if (FormUtil.isEmpty($("#customerNric").val())) {
          Common.alert("Please key in Customer NRIC.");
          return false;
      }
      else{
          if(!checkAge()){
                Common.alert("This customer is not allowed to check Pre-CCP.");
                return false;
          }
      }
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

</script>

<section id="content">

  <ul class="path"></ul>
  <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p><h2>Pre-CCP</h2>

		<ul class="right_btns">
<!--
			    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
			        <li><p class="btn_blue"><a href="javascript:void(0);" onclick="fn_preCcpRegister()">Create Pre-CCP Entry</a></p></li>
			    </c:if>
-->
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

