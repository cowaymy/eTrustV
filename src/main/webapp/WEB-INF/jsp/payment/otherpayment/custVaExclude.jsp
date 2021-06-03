<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;
var selectedGridValue;

$(document).ready(function(){
    var gridPros = {
            showStateColumn : false,
            softRemoveRowMode:false
    };

    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

});

var columnLayout = [
    { dataField:"payCustVaExcluId" ,headerText:"id",width: '5%', visible:false},
    { dataField:"custId" ,headerText:"Cust ID",width: '8%'},
    { dataField:"custName" ,headerText:"Cust Name",width: '25%'},
    { dataField:"custVa" ,headerText:"VA Number",width: '25%'},
    { dataField:"updDt" ,headerText:'<spring:message code="pay.head.updateDate" />',width: '15%'},
    { dataField:"updUsername" ,headerText:'<spring:message code="pay.head.updator" />',width: '15%'},
    { dataField : "stus", headerText : '<spring:message code="pay.head.status" />',
        editRenderer : {
        	showEditorBtnOver : true,
            type : "DropDownListRenderer",
            list : ["Active", "Inactive"]
        },
        width: '10%'
    },
    ];

/*  validation */
function validationRowCheck() {
    var resultChk = true;
    var rowCount = AUIGrid.getRowCount(myGridID);

    var EditedList = AUIGrid.getEditedRowItems(myGridID);

     if (rowCount == 0) {
         Common.alert("<spring:message code='sys.common.alert.noChange'/>");
         return false;
    } else if (EditedList.length == 0){
        Common.alert("<spring:message code='sys.common.alert.noChange'/>");
        return false;
    }

    return resultChk;
}

function fn_saveGridData(){
    Common.ajax("POST", "/payment/saveEdit.do", GridCommon.getEditData(myGridID), function(result) {
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        $("#search").trigger("click");
    }, function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

function fn_uploadFile(){

    var formData = new FormData();
    var uploadStatus = $("#uploadStatus option:selected").val();

    if(uploadStatus == ""){
        Common.alert("* Please select the Status.");
        return;
    }

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("uploadStatus", uploadStatus);

    Common.ajaxFile("/payment/custVaExcludeCsvFileUpload.do", formData, function(result){
        $('#uploadStatus option[value=""]').attr('selected', 'selected');

        Common.alert(result.message);
    });
}

function fn_close(wrap, form) {
    $(wrap).hide();
    $(form)[0].reset();
}

$(function(){
	$('#search').click(function() {
		Common.ajax("GET", "/payment/selectCustVaExcludeList.do", $("#searchForm").serialize(), function(result) {
	        AUIGrid.setGridData(myGridID, result);
	    });
	});

	$('#clear').click(function() {
		$("#searchForm")[0].reset();
    });

	$('#btnAdd').click(function() {
		$('#addCustVa_wrap').show();
	})

	$('#btnUpload').click(function() {
        $('#upload_popup_wrap').show();
    })

	$('#btnEdit').click(function() {
		if (validationRowCheck()) {
		      Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData);
		    }
    })

    $('#btnCloseAdd').click(function() {
        fn_close('#addCustVa_wrap','#addCustVaForm');
    });

	$('#btnCloseUpload').click(function() {
		fn_close('#upload_popup_wrap','');
    });



	$('#custVaBtn').click(function() {
		Common.ajaxSync("GET", "/payment/getCustIdByVaNo.do", $("#addCustVaForm").serialize(), function(result) {
			if(result != null){
				$('#_custVaId').val(result.custId);
			}else{
				Common.alert("Customer VA Number not found.");
			}
	    });
    });

	$('#_custVaNo').blur(function(){
		$(this).val($.trim($(this).val()));
	});

	$('#saveCustVaExcludeBtn').click(function() {
        if($('#_custVaNo').val() == ''){
        	Common.alert("Customer Va No is empty.");
        	return;
        }

        if($('#_custVaId').val() == ''){
            Common.alert("Customer ID is empty.");
            return;
        }

        console.log($('#_custVaNo').val());
        console.log($('#_custVaId').val());
        if($('#_custVaNo').val() != '' && $('#_custVaId').val() != ''){
        	var data = {};
        	data = {"custVa" : $('#_custVaNo').val(), "custId" : $('#_custVaId').val()};

        	Common.ajaxSync("GET", "/payment/selectCustVaExcludeList.do", data , function(result) {
        	    if(result.length > 0){
        	    	Common.alert("Customer Va No existed.<br/>Kindly edit from the grid view.");
        	    	return;
        	    }
            });
        }

/*         Common.ajax("POST", "/payment/saveCustVaExclude.do", $("#addCustVaForm").serializeJSON(), function(result) {
        	Common.alert("VA Number has saved successfully",function(){
        		fn_close();
        		$('#search').click();
        	});
        }); */
    });

});

</script>
<!-- content start -->
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Payment</li>
    <li>Payment</li>
    <li>Customer VA Exclude</li>
  </ul>
  <!-- title_line start -->
  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>Customer VA Exclude List</h2>
    <ul class="right_btns">
<%--       <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
      <li><p class="btn_blue"><a id="btnUpload">Upload</a></p></li>
      <li><p class="btn_blue"><a id="btnEdit">Save Edit</a></p></li>
      <li><p class="btn_blue"><a id="btnAdd">Add Cust Va Account</a></p></li>
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
<%--       </c:if> --%>
    </ul>
  </aside>
  <!-- title_line end -->
  <!-- search_table start -->
  <section class="search_table">
    <form name="searchForm" id="searchForm" method="post">
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 200px" />
          <col style="width: *" />
          <col style="width: 200px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">Customer ID</th>
            <td><input id="custId" name="custId" type="text"/></td>
            <th scope="row">Customer VA No.</th>
            <td><input id="custVa" name="custVa" type="text"/></td>
        </tbody>
      </table>
      <!-- table end -->
    </form>
  </section>
  <!-- search_table end -->
  <!-- search_result start -->
  <section class="search_result">
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
  </section>
  <!-- search_result end -->
</section>
<!-- content end -->

<!---------------------------------------------------------------
    POP-UP (NEW CLAIM)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap size_small" id="addCustVa_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1>Update Status</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="btnCloseAdd">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="addCustVaForm" id="addCustVaForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                <tr>
                    <th scope="row"><spring:message code='sal.text.vaNumber'/></th>
                    <td>
                        <input id="_custVaNo" name="custVaNo" type="text" title="" placeholder="Customer Va Number" class="" />
                        <a class="search_btn" id="custVaBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='sal.text.customerId'/></th>
                    <td><input id="_custVaId" name="custVaId" type="text" readonly class="readonly"/></td>
                </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a id="saveCustVaExcludeBtn" href="#">Save</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>

<div id="upload_popup_wrap" class="popup_wrap size_small" style="display:none;"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Cust VA Exclude Upload</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="btnCloseUpload"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
        <form action="#" method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                      <th scope="row">Upload Status</th>
                      <td>
                        <select class="" id="uploadStatus" name="uploadStatus">
                            <option value="">Choose One</option>
                            <option value="1">Active</option>
                            <option value="8">Inactive</option>
                        </select>
                      </td>
                    </tr>
                    <tr>
                      <th scope="row">File</th>
                      <td>
                      <div class="auto_file"><!-- auto_file start -->
                          <input type="file" title="file add" id="uploadfile" name="uploadfile" />
                      </div><!-- auto_file end -->
                      </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/payment/CustVaExclude_Format.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
        </ul>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->