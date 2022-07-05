<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	var myGridIDItem;

	//Init Option
	var ComboOption = {
	      type: "S",
	      chooseMessage: "Select Item Type",
	      isShowChoose: false  // Choose One 등 문구 보여줄지 여부.
	};

	var ItmOption = {
	      type: "S",
	      isCheckAll: false
	};


    $(document).ready(function() {

    	selectItemList();
        $('#cancelBtn').click(function() {
            $('#btnPopClose').trigger("click");
        });

        $('#saveBtn').click(function() {
        	fn_promptUpdateRedemption();
        });

    });

    function validateUpdForm() {
        if ($("#rdmStatus").val() == '') {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Action' htmlEscape='false'/>");
            return false;
        }
        return true;
    }

    function fn_promptUpdateRedemption() {

        var confirmSaveMsg = "Do you want to save with above information?";

        Common.confirm(confirmSaveMsg, updateRedemption);
    }

    function updateRedemption() {
        if (validateUpdForm()) {

            var updateRdmData = {
            	rdmId : '${rdmId}',
                rdmStatus : $("#rdmStatus").val(),
                rdmRemark : $("#rdmRemark").val()
            };

            Common.ajax("POST", "/incentive/goldPoints/updateRedemption.do", updateRdmData, function(result) {
                if(result.code == "00") {        //successful update

                	   Common.alert(" Update status successful " + "<br />Status: " + $("#rdmStatus option:selected").text());
//                 	Common.alert(" Update status successful for Redemption No: " + $("#_rdmNo").val()
//                 			+ "<br />Status: " + $("#rdmStatus option:selected").text());
                } else {
                    Common.alert(result.message);
                }
                $("#updateRedemptionPop").remove();
                fn_searchRedemptionList();
            });
        }
    }


    function selectItemList(){


        var gridProsItem = {
        		   usePaging : true,
                   pageRowCount : 10,
                   editable : false,
                   showStateColumn : false,
                   showRowNumColumn : true,
                   wordWrap : true,
                   headerHeight : 45
        };

        var columnLayout = [
                            {dataField: "rdmNo",headerText :"Redemption No." ,width: 100   ,height:30 , visible:true, editable : false},
                            {dataField: "memCode",headerText :"Member Code", width: 280    ,height:30 , visible:true, editable : false},
                            {dataField: "memName" ,headerText :"Member Name" , width:120 ,height:30 , visible:true, editable : true},
                            {dataField: "nric" ,headerText :"NRIC" ,width:140 ,height:30 , visible:true, editable : false},
                            {dataField: "itmCat" ,headerText :"Category"  ,width:120 ,height:30 , visible:true, editable : false},
                            {dataField: "itmDisplayName" ,headerText :"Item" ,width:120 ,height:30 , visible:true, editable : false},
                            {dataField: "qty" ,headerText :"Quantity" ,width:120   ,height:30 , visible:true, editable : false},
                            {dataField: "totalPts" ,headerText :"Total Points" ,width:120   ,height:30 , visible:true, editable : false},
                            {dataField: "rdmId" ,headerText :"rdmId" ,width:120   ,height:30 , visible:false, editable : false}
         ];

       myGridIDItem = GridCommon.createAUIGrid("#item_grid_wrap", columnLayout,'', gridProsItem);

       var param = '${rdmId}';

       Common.ajax("GET", "/incentive/goldPoints/selectRedemptionDetails", { rdmId : param }, function(result) {
           AUIGrid.setGridData(myGridIDItem, result);
       });


}


</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1><spring:message code="incentive.title.goldPtsRdmUpdStatus" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnPopClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header><!-- pop_header end -->

  <section class="pop_body"><!-- pop_body start -->


<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

    <aside class="title_line"><!-- title_line start -->
      <h3>Update Status:</h3>
    </aside><!-- title_line end -->
    <form action="#" method="post" name="updateForm" id="updateForm">
      <input id="_rdmId" name="rdmId" type="hidden" value="" />
      <input id="_rdmNo" name="rdmNo" type="hidden" value="" />
      <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width:160px" />
          <col style="width:*" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">Action</th>
            <td>
              <select id="rdmStatus" name="rdmStatus">
                <option value=""></option>
                <option value="110">Ready For Collect</option>
                <option value="4">Completed</option>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row">Remark</th>
            <td><textarea cols="20" rows="2" type="text" id="rdmRemark" name="rdmRemark" maxlength="150" placeholder="Enter up to 150 characters"/></td>
          </tr>
        </tbody>
      </table><!-- table end -->

      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="saveBtn">Save</a></p></li>
        <li><p class="btn_blue2 big"><a href="#" id="cancelBtn">Cancel</a></p></li>
      </ul>

    </form>

  </section><!-- pop_body end -->

</div><!-- popup_wrap end -->