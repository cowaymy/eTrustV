<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


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
          showRowCheckColumn : false,
          usePaging : true,
          pageRowCount : 20,
          showRowAllCheckBox : true,
          editable : false
  };

  $(document).ready(function() {
	  preCcpGrid();
	  f_multiCombo();

	  $("#custName").unbind().bind("change keyup", function(){
          $(this).val($(this).val().toUpperCase());
       });

	  $("#requestor").unbind().bind("change keyup", function(){
          $(this).val($(this).val().toUpperCase());
       });
  });

  function preCcpGrid() {
    let columnLayout = [
        {
          dataField : "preccpSeq",
          headerText : "Pre-CCP Seq.",
          editable : false,
          width : 200,
          visible: false
        },
        {
          dataField : "custName",
          headerText : "Customer Name",
          editable : false,
          width : 200
        },
        {
          dataField : "custIc",
          headerText : "NRIC",
          width : 200
        },
        {
          dataField : "custMobileno",
          headerText : "Mobile No.",
          width : 150
        },
        {
          dataField : "custEmail",
          headerText : "Email address",
          width : 200
        },
        {
          dataField : "chsStatus",
          headerText : "CHS Status",
          width : 200
        },
        {
          dataField : "crtDt",
          headerText : "Register Date",
          editable : false,
          width : 150
        },
        {
          dataField : "creator",
          headerText : "Creator",
          editable : false,
          width : 150
        },
    ];

    myGridID = AUIGrid.create("#grid_wrap_preCcpList", columnLayout, gridPros);
  }

  function fn_excelDown() {
    GridCommon.exportTo("grid_wrap_preCcpList", "xlsx", "Pre-CCP Register");
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
              if($("#memType").val() != "7"){ //check not HT level
                   this.selectedIndex = 0;
              }
          }
      });
  };

  function fn_preCcpRegister(){
      Common.popupDiv("/sales/ccp/preCcpSubmissionRegister.do", null, null, true, '');
  }

  function f_multiCombo() {
    $(function() {
        $('#preccpStatus').change(function() {
        }).multipleSelect({
            selectAll : false
        });
    });
  }

  function fn_validation() {

      if ($("#registerDtFrm").val() == '' || $("#registerDtTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='register date (From & To)' htmlEscape='false'/>");
        return false;
      }

      let dtRange = 31;

      if ($("#registerDtFrm").val() != '' || $("#registerDtTo").val() != '') {

              let keyInDateFrom = $("#registerDtFrm").val().substring(3, 5) + "/" + $("#registerDtFrm").val().substring(0, 2) + "/" + $("#registerDtFrm").val().substring(6, 10);
              let keyInDateTo = $("#registerDtTo").val().substring(3, 5) + "/" + $("#registerDtTo").val().substring(0, 2) + "/" + $("#registerDtTo").val().substring(6, 10);
              let date1 = new Date(keyInDateFrom);
              let date2 = new Date(keyInDateTo);

              let diff_in_time = date2.getTime() - date1.getTime();
              let diff_in_days = diff_in_time / (1000 * 3600 * 24);

              if (diff_in_days > dtRange) {
                Common.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
                return false;
              }
        }
        return true;
  }


  function fn_searchPreCcpRegisterList(){
	  var isVal = true;
      isVal = fn_validation();

      if(isVal == false){
          return;
      }else{
          Common.ajax("GET", "/sales/ccp/searchPreCcpRegisterList.do", $("#preCcpForm").serialize(), function(result) {
        	  console.log(result)
            AUIGrid.setGridData(myGridID, result);
          });
      }
  }

</script>

<section id="content">

  <ul class="path"></ul>
  <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p><h2>Pre-CCP Register</h2>

		<ul class="right_btns">
			    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
			        <li><p class="btn_blue"><a href="javascript:void(0);" onclick="fn_preCcpRegister()">Create Pre-CCP Entry</a></p></li>
			    </c:if>

			   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
			        <li><p class="btn_blue"><a href="javascript:void(0);" onClick="fn_searchPreCcpRegisterList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			   </c:if>

		        <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:$('#preCcpForm').clearForm();"><span class="clear"></span><spring:message code='service.btn.Clear'/></a></p></li>
		</ul>
 </aside>

 <section class="search_table">
  <form action="#" method="post" id="preCcpForm">
   <table class="type1">
	    <caption>table</caption>
	    <colgroup>
		     <col style="width: 150px" />
		     <col style="width: *" />
		     <col style="width: 140px" />
		     <col style="width: *" />
		     <col style="width: 170px" />
		     <col style="width: *" />
        </colgroup>

    <tbody>
	     <tr>
		     <th scope="row"><spring:message code='service.grid.CustomerName'/></th>
		     <td><input type="text" title="" placeholder="<spring:message code='service.grid.CustomerName'/>" class="w100p" id="custName" name="custName" /></td>

		     <th scope="row">NRIC</th>
		     <td><input type="text" title="" placeholder="NRIC" class="w100p" id="nric" name="nric" /></td>

		     <th scope="row">Mobile No.</th>
             <td><input type="text" title="" placeholder="Mobile No." class="w100p" id="mobileNo" name="mobileNo" /></td>
	     </tr>



	     <tr>
	         <th scope="row">Email Address</th>
             <td><input type="text" title="" placeholder="Email Address." class="w100p" id="emailAddr" name="emailAddr" /></td>

		     <th scope="row">CHS Status</th>
		     <td>
		          <select class="w100p" multiple="multiple" id="preccpStatus" name="preccpStatus">
			        <c:forEach var="list" items="${preccpStatus}" varStatus="preccpStatus">
			             <option value="${list.codeId}" selected>${list.codeName}</option>
			        </c:forEach>
                  </select>
             </td>


	         <th scope="row"><spring:message code='service.grid.registerDt'/></th>
		     <td>
			       <div class="date_set w100p">
				        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="registerDtFrm" name="registerDtFrm" /></p>
				        <span><spring:message code='pay.text.to'/></span>
				        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="registerDtTo" name="registerDtTo" /></p>
			       </div>
		      </td>
	     </tr>

	     <tr>
		       <th scope="row"><spring:message code='service.title.requestor' /></th>
		       <td><input type="text" class="w100p" id="requestor" name="requestor" /></td>

		       <th></th>
		       <td></td>

		       <th></th>
		       <td></td>
	     </tr>
    </tbody>
   </table>
  </form>

 <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
            <li><p class="btn_grid"><a href="javascript:void(0);" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a></p></li>
    </c:if>
 </ul>

   <article class="grid_wrap">
        <div id="grid_wrap_preCcpList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>

 </section>
</section>

