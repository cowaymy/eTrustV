<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var autoDebitGridID;
     let tabAutoDebitandEcash= $("#tabAutoDebitandEcash").val();
     let tabHcAutoDebitandEcash= $("#tabHcAutoDebitandEcash").val();
     let tabCdAutoDebitandEcash= $("#tabCdAutoDebitandEcash").val();

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid7();
    });


    function createAUIGrid7() {

         console.log("Value of authValue:", tabAutoDebitandEcash);
         console.log("Value of authValue HC:", tabHcAutoDebitandEcash);
         console.log("Value of authValue CD:", tabCdAutoDebitandEcash);

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.mnth" />',       dataField : "crtDtMm",      width : "10%" }
          , { headerText : '<spring:message code="sal.title.text.mode" />', dataField : "batchMode",    width : "10%" }
    /*       , { headerText : '<spring:message code="sal.title.text.bank" />', dataField : "code"                      } // edited by Tommy 14/01/2019 */
          , { headerText : '<spring:message code="sal.text.dateDeduct" />', dataField : "crtDtDd",      width : "15%" }
          , { headerText : '<spring:message code="sal.title.amount" />',    dataField : "bankDtlAmt",   width : "10%" }
          , { headerText : '<spring:message code="sal.text.isSuccess" />',  dataField : "isApproveStr", width : "20%" }
          ];

         if (tabAutoDebitandEcash=="Y" || tabHcAutoDebitandEcash=="Y" || tabCdAutoDebitandEcash=="Y") {

        	 document.getElementById('downloadButtonContainer').style.display = 'block';
            columnLayout.push(
                { headerText: '<spring:message code="sal.text.fileItmRespnsCode" />', dataField: "bankDtlApprCode", width: "10%" }
                , { headerText: '<spring:message code="sal.text.descCode" />', dataField: "descCode", width: "30%" }
            );
        }

        autoDebitGridID = GridCommon.createAUIGrid("grid_autoDebit_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectAutoDebitList() {
        Common.ajax("GET", "/sales/order/selectAutoDebitJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(autoDebitGridID, result);
        });
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="downloadButtonContainer" style="display: none;">
  <ul class="left_opt">
    <li>
      <h1 style="display: inline;">Bank Response Code: </h1>
      <a href="${pageContext.request.contextPath}/resources/download/sales/BankFullResponseCode_V2.pdf" download>
        <button>Download</button>
      </a>
    </li>
  </ul>
</div>
</br>
<div id="grid_autoDebit_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->