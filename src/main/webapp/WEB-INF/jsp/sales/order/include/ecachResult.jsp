<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var ecashGridID;
    let tabAutoDebitandEcash= $("#tabAutoDebitandEcash").val();
    let tabHcAutoDebitandEcash= $("#tabHcAutoDebitandEcash").val();
    let tabCdAutoDebitandEcash= $("#tabCdAutoDebitandEcash").val();

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid9();
        displayEcashValidity();
    });


    function createAUIGrid9() {

    	console.log("Value of authValue 2:", tabAutoDebitandEcash);
    	console.log("Value of authValue 2 HC:", tabHcAutoDebitandEcash);
    	console.log("Value of authValue 2 CD:", tabCdAutoDebitandEcash);
        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.deductDt" />',  dataField : "fileItmCrt",    width : 120 }
          , { headerText : '<spring:message code="sal.title.payType" />',  dataField : "codeName" }
          , { headerText : '<spring:message code="sal.title.amount" />',   dataField : "fileItmAmt",    width : 100 }
          , { headerText : '<spring:message code="sal.text.isSuccess" />', dataField : "isSuccess",     width : 80 }
          , { headerText : '<spring:message code="sal.text.reason" />',    dataField : "fileItmRem",    width : 260 }
          ];

        if (tabAutoDebitandEcash=="Y" || tabHcAutoDebitandEcash=="Y" || tabCdAutoDebitandEcash=="Y") {

        	 document.getElementById('downloadButtonContainer2').style.display = 'block';
            columnLayout.push(
            { headerText : '<spring:message code="sal.text.fileItmRespnsCode" />',    dataField : "fileItmRespnsCode",    width : 120 }
          , { headerText : '<spring:message code="sal.text.descCode" />',    dataField : "descCode",    width : 260 }
            );
        }

        ecashGridID = GridCommon.createAUIGrid("grid_ecash_wrap", columnLayout, "", gridPros);
    }

    // 리스트 조회.
    function fn_selectEcashList() {
        Common.ajax("GET", "/sales/order/selectEcashList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(ecashGridID, result);
        });
    }

    function displayEcashValidity(){
    	if(`${orderDetail.basicInfo.appTypeDesc}` == "Rental"){
	    	let orderDt =  `${orderDetail.basicInfo.ordDt}`;
	    	const getDateArray = orderDt.split(" ");
	    	const startDate = moment(getDateArray[0]).format('DD/MM/YYYY');
	    	const endDate = moment(getDateArray[0]).add(30, 'days').format('DD/MM/YYYY');
	    	document.querySelector("#ecashValidityPeriod").innerHTML = `<h1>eCash validity period : ` + startDate + ` - `+ endDate + `</h1>`
    	}
    }

</script>
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ecashValidityPeriod"></div>
<br/>
<div id="downloadButtonContainer2" style="display: none;">
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
<div id="grid_ecash_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="left_opt">
    <li><span class="red_text">**</span> <span class="brown_text"><spring:message code="sal.msg.ecashRslt" /></span></li>
</ul>
</article><!-- tap_area end -->