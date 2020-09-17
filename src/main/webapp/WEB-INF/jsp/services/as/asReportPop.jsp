<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 26/04/2019  ONGHC  1.0.0          ADD RECALL STATUS
 28/08/2019  ONGHC  1.0.1          AMEND LAYOUT
 03/09/2019  ONGHC  1.0.2          AMEND REPORT FILTER LAYOUT
 -->
<script type="text/javaScript">
  $(document).ready(
      function() {
        $('.multy_select').on("change", function() {
        }).multipleSelect({});

        doGetComboSepa("/common/selectBranchCodeList.do", 5, '-', '', 'branch', 'S', '');
        /* doGetCombo('/services/as/report/selectMemCodeList.do', '', '', 'CTCodeFrom', 'S', '');
        doGetCombo('/services/as/report/selectMemCodeList.do', '', '', 'CTCodeTo', 'S', ''); */
        doGetCombo('/services/holiday/selectBranchWithNM', 43, '', 'cmbbranchId2', 'S', ''); // DSC BRANCH

        $("#cmbbranchId2").change(
            function() {
              //doGetComboData('/services/as/selectCTByDSC.do', $("#cmbbranchId2").val(), '', 'cmbctId2', 'M', 'fn_multiCombo');
              doGetCombo('/services/as/selectCTByDSC.do', $("#cmbbranchId2").val(), '', 'cmbctId2', 'M', 'fn_multiCombo');
            }); // INCHARGE CT
      });

  function fn_multiCombo() {
    $('#cmbctId2').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });
  }

  function fn_validation() {
    if ($("#asAppDtFr").val() == '' && $("#asAppDtTo").val() == '') {
      if ($("#reqStrDate").val() == '' && $("#reqEndDate").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='either AS request date or AS Appointment date (From & To)' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#reqStrDate").val() == '' && $("#reqEndDate").val() == '') {
      if ($("#asAppDtFr").val() == '' && $("#asAppDtTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='either AS request date or AS Appointment date (From & To)' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#asAppDtFr").val() != '') {
      if ($("#asAppDtTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Appointment Date' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#asAppDtTo").val() != '') {
      if ($("#asAppDtFr").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Appointment Date' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#reqStrDate").val() != '') {
      if ($("#reqEndDate").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Request Date' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#reqEndDate").val() != '') {
      if ($("#reqStrDate").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Request Date' htmlEscape='false'/>");
        return false;
      }
    }

    if ($("#reqStrDate").val() != '' && $("#asAppDtFr").val() != '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='either AS request date or AS Appointment date (From & To)' htmlEscape='false'/>");
      return false;
    }

/*     if ($("#cmbctId2").val() == '' || $("#cmbctId2").val() == null) {
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='CT code' htmlEscape='false'/>");
          return false;
       } */

    if ($("#cmbbranchId2").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='DSC Branch' htmlEscape='false'/>");
      return false;
    }

    /*if ($("#orderNumFrom").val() == '' || $("#orderNumTo").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='order number (From & To)' htmlEscape='false'/>");
      return false;
    }

    if ($("#CTCodeFrom").val() == '' || $("#CTCodeTo").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='CT code (From & To)' htmlEscape='false'/>");
      return false;
    }

    if ($("#branch").val() == '' || $("#branch").val() == null) {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='DSC Branch' htmlEscape='false'/>");
      return false;
    }*/
    return true;
  }

  function fn_openGenerate() {
    if (fn_validation()) {
      var fSONO1 = $("#orderNumFrom").val();
      var fSONO2 = $("#orderNumTo").val();
      var fMemCTID1 = $("#CTCodeFrom").val();
      var fMemCTID2 = $("#CTCodeTo").val();
      var reqDate1 = "";
      var reqDate2 = "";
      var appDate1 = "";
      var appDate2 = "";
      var whereSql = "";
      var dscBranch = "";
      var ctCodeLst = "";

      //Added by TPY - 20190903
      var orderNo = $("#orderNumFrom").val();
      var ctCode = $("#cmbctId2").val();
      var dscBranchCode = $("#cmbbranchId2").val();
      var asNumber = $("#asNum").val();

      var orderBy = " t1.F_MEM_CODE ";

      if ($("#asAppDtFr").val() != '') {
        appDate1 = $("#asAppDtFr").val();
        appDate2 = $("#asAppDtTo").val();

        if (appDate2 != '') {
          whereSql += " AND (AE.AS_APPNT_DT >= TO_DATE('"
              + appDate1
              + "', 'DD/MM/YYYY') AND AE.AS_APPNT_DT <= TO_DATE('"
              + appDate2 + "' , 'DD/MM/YYYY')) ";
        } else {
          whereSql += "";
        }

      } else {
        reqDate1 = $("#reqStrDate").val();
        reqDate2 = $("#reqEndDate").val();

        if (reqDate1 != '' && reqDate2 != '') {
          whereSql += " AND (AE.AS_REQST_DT >= TO_DATE('"
              + reqDate1
              + "', 'DD/MM/YYYY') AND AE.AS_REQST_DT <= TO_DATE('"
              + reqDate2 + "' , 'DD/MM/YYYY')) ";
        } else {
          whereSql += "";
        }
      }

      if ($("#sortType").val() == 'AS') {
        orderBy = " t1.AS_NO ";
      }

      /* if ($("#branch").val() != '' && $("#branch").val() != null) {
        dscBranch = " WHERE t1.Brnch_Code LIKE '" + $("#branch option:selected").text().substring(0, 6) + "%' ";
      } */

      //Added by TPY - 20190903
      if ($("#orderNumFrom").val() != '') {
        whereSql += " AND AE.AS_SO_ID = (SELECT SALES_ORD_ID FROM SAL0001D WHERE SALES_ORD_NO = '"
            + orderNo + "')  ";
      }

      if ($("#asNum").val() != '') {
        whereSql += " AND AE.AS_NO =  '" + asNumber + "' ";
      }


	if (ctCode.length > 0) {
				for (var a = 0; a < ctCode.length; a++) {
					if (a == 0) {
						ctCodeLst += "'" + ctCode[a] + "'"
					} else {
						ctCodeLst += ", '" + ctCode[a] + "'"
					}
				}
				whereSql += " AND AE.AS_MEM_ID IN (SELECT MEM_ID FROM ORG0001D WHERE MEM_CODE IN ("
						+ ctCodeLst + ")) ";
			}

			if ($("#cmbbranchId2").val() != '') {
				whereSql += " AND AE.AS_BRNCH_ID = (SELECT BRNCH_ID FROM SYS0005M WHERE CODE = '"
						+ dscBranchCode
						+ "' AND TYPE_ID = 43 AND STUS_ID = 1 ) ";
			}

			// homecare Remove(except)
			whereSql += " AND AF.BNDL_ID IS NULL ";

			var date = new Date();
			var month = date.getMonth() + 1;
			var day = date.getDate();
			if (date.getDate() < 10) {
				day = "0" + date.getDate();
			}

			$("#reportFormASR #V_FSONO1").val(fSONO1);
			$("#reportFormASR #V_FSONO2").val(fSONO2);
			$("#reportFormASR #V_FMEMCTID1").val(fMemCTID1);
			$("#reportFormASR #V_FMEMCTID2").val(fMemCTID2);
			$("#reportFormASR #V_ORDERBY").val(orderBy);
			$("#reportFormASR #V_DSCBRANCH").val(dscBranch);
			$("#reportFormASR #V_WHERESQL").val(whereSql);
			$("#reportFormASR #reportFileName").val('/services/ASReport.rpt');
			$("#reportFormASR #viewType").val("PDF");
			$("#reportFormASR #reportDownFileName").val(
					"ASReport_" + day + month + date.getFullYear());

			var option = {
				isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
			};

			Common.report("reportFormASR", option);
		}
	}

	$.fn.clearForm = function() {
		return this.each(function() {
			var type = this.type, tag = this.tagName.toLowerCase();
			if (tag === 'form') {
				return $(':input', this).clearForm();
			}

			if (type === 'text' || type === 'password' || type === 'hidden'
					|| tag === 'textarea') {
				this.value = '';
			} else if (type === 'checkbox' || type === 'radio') {
				this.checked = false;
			} else if (tag === 'select') {
				this.selectedIndex = 0;
			}
		});
	};
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='service.btn.asRpt' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" id="reportFormASR">
    <input type="hidden" id="V_FSONO1" name="V_FSONO1" /> <input
     type="hidden" id="V_FSONO2" name="V_FSONO2" /> <input
     type="hidden" id="V_FMEMCTID1" name="V_FMEMCTID1" /> <input
     type="hidden" id="V_FMEMCTID2" name="V_FMEMCTID2" /> <input
     type="hidden" id="V_ORDERBY" name="V_ORDERBY" /> <input
     type="hidden" id="V_DSCBRANCH" name="V_DSCBRANCH" /> <input
     type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 190px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.grid.ReqstDt' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="reqStrDate"
           name="reqStrDate" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="reqEndDate"
           name="reqEndDate" />
         </p>
        </div> <!-- date_set end -->
       </td>
       <th scope="row"><spring:message
         code='service.title.AppointmentDate' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_date" id="asAppDtFr"
           name="asAppDtFr" />
         </p>
         <span><spring:message code='svc.hs.reversal.to' /></span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_date" id="asAppDtTo"
           name="asAppDtTo" />
         </p>
        </div> <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.OrderNo' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <input type="text" title="" placeholder="Order No"
          class="w100p" id="orderNumFrom" name="orderNumFrom"
           />
        </div> <!-- date_set end -->
       </td>
       <th scope="row"><spring:message code='service.grid.ASNo' /></th>
       <td>
        <div class="date_set">
         <input type="text" title=""
          placeholder="<spring:message code='service.grid.ASNo'/>"
          class="w100p" id="asNum" name="asNum" />
        </div>
       </td>
      </tr>
      <tr>
       <%-- <th scope="row"><spring:message code='service.title.CTCode' /> (<spring:message code='svc.hs.reversal.from' />) <span class='must'> *</span></th>
       <td><select id="CTCodeFrom" name="CTCodeFrom">
       </select></td>
       <th scope="row"><spring:message code='service.title.CTCode' /> (<spring:message code='svc.hs.reversal.to' />) <span class='must'> *</span></th>
       <td><select id="CTCodeTo" name="CTCodeTo">
       </select></td> --%>
       <th scope="row"><spring:message
         code='service.title.DSCBranch' /> <span class='must'> *</span></th>
       <td><select id="cmbbranchId2" name="cmbbranchId2">
       </select></td>
       <th scope="row"><spring:message code='service.grid.CTCode' /></th>
       <td><select id="cmbctId2" name="cmbctId2" class="multy_select w100p" multiple="multiple">
       </select></td>
      </tr>
      <tr>
       <%-- <th scope="row"><spring:message code='service.title.AppointmentDate' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="asAppDtFr" name="asAppDtFr" />
         </p>
         <span><spring:message code='svc.hs.reversal.to' /></span>
         <p>
          <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="asAppDtTo" name="asAppDtTo" />
         </p>
        </div>
        <!-- date_set end -->
       </td> --%>
       <%-- <th scope="row"><spring:message code='service.title.DSCBranch' /> <span class='must'> *</span></th>
       <td><select id="branch" name="branch">
       </select></td> --%>
      </tr>
      <tr>
       <td colspan="2">
        <p>
         <span style="color: red; font-weight: bold">* Please
          Choose either Appointment Date or Request Date</span>
        </p>
       </td>
       <th scope="row"><spring:message code='service.title.SortBy' /></th>
       <td><select id="sortType" name="sortType">
         <option value="AS"><spring:message
           code='service.grid.ASNo' /></option>
         <option value="CT"><spring:message
           code='service.title.CTCode' /></option>
       </select></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#" onclick="javascript:fn_openGenerate()"><spring:message
       code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#" onclick="javascript:$('#reportFormASR').clearForm();"><spring:message
       code='service.btn.Clear' /></a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
