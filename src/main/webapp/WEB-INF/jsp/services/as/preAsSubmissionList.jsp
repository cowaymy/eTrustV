<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
    var myGridID;

    var gridPros = {
            showRowCheckColumn : false,
            usePaging : true,
            pageRowCount : 20,
            showRowAllCheckBox : true,
            editable : false
    };

    var columnLayout = [
          {
            dataField : "salesOrderNo",
            headerText : "Order No",
            editable : false,
            width : 200
          },
          {
            dataField : "status",
            headerText : "Status",
            editable : false,
            width : 150
          },
          {
             dataField : "defectCode",
             headerText : "Defect Code",
             editable : false,
             width : 150
          },
          {
             dataField : "defectDesc",
             headerText : "Defect Description",
             editable : false,
             width : 300
           },
           {
              dataField : "remark",
              headerText : "Remark",
              editable : false,
              width : 300
           },
           {
             dataField : "regDt",
             headerText : "Register Date",
             editable : false,
             width : 150
           },
     ];


    function loadMemberDetails(){
        if($("#memType").val() == 1 || $("#memType").val() == 2 || $("#memType").val() == 7){

            if("${SESSION_INFO.memberLevel}" =="1"){
                $("#preAsOrgCode").attr("class", "w100p readonly");
                $("#preAsOrgCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="2"){

                $("#preAsOrgCode").attr("class", "w100p readonly");
                $("#preAsOrgCode").attr("readonly", "readonly");

                $("#preAsGrpCode").attr("class", "w100p readonly");
                $("#preAsGrpCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="3"){

                $("#preAsOrgCode").attr("class", "w100p readonly");
                $("#preAsOrgCode").attr("readonly", "readonly");

                $("#preAsGrpCode").attr("class", "w100p readonly");
                $("#preAsGrpCode").attr("readonly", "readonly");

                $("#preAsDeptCode").attr("class", "w100p readonly");
                $("#preAsDeptCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="4"){

                $("#preAsOrgCode").attr("class", "w100p readonly");
                $("#preAsOrgCode").attr("readonly", "readonly");

                $("#preAsGrpCode").attr("class", "w100p readonly");
                $("#preAsGrpCode").attr("readonly", "readonly");

                $("#preAsDeptCode").attr("class", "w100p readonly");
                $("#preAsDeptCode").attr("readonly", "readonly");

            }
        }
    }


	$(document).ready(function() {
		myGridID = AUIGrid.create("#grid_wrap_preAsSubmissionList", columnLayout, gridPros);

		f_multiCombo();

		loadMemberDetails();

	});

	function fn_registerRequest(){
		Common.popupDiv("/services/as/preAsSubmissionRegister.do", null, null, true, '');
	}

	function fn_searchPreAsSubmission(){
	    var isVal = true;

        isVal = fn_validation();

        if(isVal == false){
            return;
        }else{
            console.log($("#preAsSubmissionForm").serialize());
            Common.ajax("GET", "/services/as/searchPreAsSubmissionList.do", $("#preAsSubmissionForm").serialize(), function(result) {
            console.log(result);
              AUIGrid.setGridData(myGridID, result);
            });
        }
	}

  function fn_validation() {

        if ($("#preAsRegDtFrom").val() == '' || $("#preAsRegDtTo").val() == '') {
          Common.alert("<spring:message code='sys.common.alert.validation' arguments='register date (From & To)' htmlEscape='false'/>");
          return false;
        }

        var dtRange = 31;

        if ($("#preAsRegDtFrom").val() != '' || $("#preAsRegDtTo").val() != '') {
                var keyInDateFrom = $("#preAsRegDtFrom").val().substring(3, 5) + "/"
                                  + $("#preAsRegDtFrom").val().substring(0, 2) + "/"
                                  + $("#preAsRegDtFrom").val().substring(6, 10);

                var keyInDateTo = $("#preAsRegDtTo").val().substring(3, 5) + "/"
                                + $("#preAsRegDtTo").val().substring(0, 2) + "/"
                                + $("#preAsRegDtTo").val().substring(6, 10);

                var date1 = new Date(keyInDateFrom);
                var date2 = new Date(keyInDateTo);

                var diff_in_time = date2.getTime() - date1.getTime();

                var diff_in_days = diff_in_time / (1000 * 3600 * 24);

                if (diff_in_days > dtRange) {
                  Common.alert("<spring:message code='sys.common.alert.dtRangeNtMore' arguments='" + dtRange + "' htmlEscape='false'/>");
                  return false;
                }
          }
          return true;
    }

  function f_multiCombo() {

	    $('#preAsSubmissionStatus').change(function() {
	    }).multipleSelect({
	      selectAll : true,
	      width : '80%'
	    });

      $(function() {
          $('#preAsErrorCode').change(function() {
          }).multipleSelect({
              selectAll : false
          });
      });
  }

  $.fn.clearForm = function() {
      return this.each(function() {
          var type = this.type, tag = this.tagName.toLowerCase();
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
      loadMemberDetails();
  };


</script>
<section id="content">
 <!-- content start -->

 <ul class="path"></ul>

 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>Pre-AS Submission</h2>

  <ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="fn_registerRequest()">Register</a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="fn_searchPreAsSubmission()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
   <li><p class="btn_blue"><a href="#" onclick="javascript:$('#preAsSubmissionForm').clearForm();"><span class="clear"></span><spring:message code='service.btn.Clear'/></a></p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form action="#" method="post" id="preAsSubmissionForm">
   <input type="hidden" name="memType" id="memType" value="${memType}"/>
   <input type="hidden" name="orderType" id="orderType" value="HA"/>
   <table class="type1">
    <!-- table start -->
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
	         <th scope="row">Org Code</th>
	         <td><input type="text"  class="w100p" id="preAsOrgCode" name="preAsOrgCode" value="${orgCode}".trim()/></td>

	         <th scope="row">Grp Code</th>
	         <td><input type="text"  class="w100p" id="preAsGrpCode" name="preAsGrpCode" value="${grpCode}".trim()/></td>

	         <th scope="row">Dept Code</th>
	         <td><input type="text"  class="w100p" id="preAsDeptCode" name="preAsDeptCode" value="${deptCode}".trim()/></td>
     </tr>

     <tr>
	     <th scope="row"><spring:message code='service.title.OrderNumber'/></th>
	     <td><input type="text"  class="w100p" id="preAsOrdNo" name="preAsOrdNo" /></td>


      <th scope="row"><spring:message code='service.title.Status'/></th>
      <td><select class="w100p" multiple="multiple" id="preAsSubmissionStatus" name="preAsSubmissionStatus">
        <c:forEach var="list" items="${asStat}" varStatus="preAsSubmissionStatus">
             <option value="${list.codeId}" selected>${list.codeName}</option>
        </c:forEach>
      </select></td>

         <th scope="row">Register Date</th>
         <td>
          <div class="date_set w100p">
	           <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="preAsRegDtFrom" name="preAsRegDtFrom" /></p>
	           <span><spring:message code='pay.text.to'/></span>
	           <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="preAsRegDtTo" name="preAsRegDtTo" /></p>
          </div>
          </td>
     </tr>

     <tr>
         <th scope="row">Error Code</th>
<!--          <td><select class="w100p" id="preAsErrorCode" name="preAsErrorCode"></select></td> -->
         <td><select class="w100p" multiple="multiple" id="preAsErrorCode" name="preAsErrorCode">
        <c:forEach var="list" items="${haErrorCodeList}" varStatus="preAsErrorCode">
             <option value="${list.codeId}" selected>${list.codeName}</option>
        </c:forEach>
      </select></td>

         <th scope="row">Remark</th>
         <td><input type="text"  class="w100p" id="preAsRemark" name="preAsRemark" /></td>

         <th></th>
         <td></td>
     </tr>


    </tbody>
   </table>
   <!-- table end -->

   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_preAsSubmissionList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
</section>
<!-- content end -->
