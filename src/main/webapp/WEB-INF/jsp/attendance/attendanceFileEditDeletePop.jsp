<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    var calGridID;

    $(document).ready(function() {
        createAUIGrid();

        $("#calSearchBtn").click(function() {
            fn_getCalSearchResultJsonList();
        });

    });

    function fn_getCalSearchResultJsonList() {
        Common.ajax("GET", "/attendance/searchAtdUploadList.do", $("#calSearchEditDeleteForm").serialize(), function(result){
            AUIGrid.setGridData(calGridID, result);
        });
    }

    function createAUIGrid() {
        var calColumnLayout = [

               {dataField: "" ,
                 width: "10%",
                 headerText: "",
                 editable: false,
                 renderer: {
                      type : "IconRenderer",
                      iconTableRef :  {
                            "default" : "${pageContext.request.contextPath}/resources/images/common/icon_gabage_s.png"// default
                      },
                      iconWidth : 16,
                      iconHeight : 16,
                      onclick : function(rowIndex, columnIndex, value, item) {
                    	  var confirmSaveMsg = "Are you sure want to Delete?";
                          Common.confirm(confirmSaveMsg, x=function() { fn_removeItem(item.batchId)});

                      }
                 }
               },
               {dataField: "batchId", headerText: "Upload Batch No", visible: true, editable: false},
               {dataField: "batchMthYear", headerText: "Month Year", editable: false, width: "15%"},
               {dataField: "memType", headerText: "Member Type", editable: false, width: "20%"},
               {dataField: "batchMemType", headerText: "Member Type", visible:false ,editable: false, width: "20%"},
               {dataField: "atchFileName",headerText :"Attachement"      ,width:180   ,height:30 , visible:true,editable : false,
                   renderer :
                   {
                         type : "IconRenderer",
                         iconWidth : 23, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                         iconHeight : 23,
                         iconPosition : "aisleRight",
                         iconFunction : function(rowIndex, columnIndex, value, item)
                         {
                           return "${pageContext.request.contextPath}/resources/images/common/normal_search.png";
                         } ,// end of iconFunction
                         onclick : function(rowIndex, columnIndex, value, item) {
                        	 var confirmReuploadMsg = "Are you sure want to Reupload attendance listing for this batch : " +item.batchId + "?";
                             Common.confirm(confirmReuploadMsg, x=function() { updateAttachUpLoad(rowIndex, columnIndex, value, item)});
                         }
                     } // IconRenderer
                  }
        ];

        var gridPros = {
                usePaging : true,
                pageRowCount : 20,
                showRowNumColumn : false
        };

        calGridID = GridCommon.createAUIGrid("#cal_grid_wrap", calColumnLayout, "eventId", gridPros);
    }

    function fn_removeItem(batchId) {
        Common.ajax("POST", "/attendance/deleteUploadBatch.do", {"batchId": batchId}, function(result) {
            Common.alert(result.message, fn_getCalSearchResultJsonList);
        });
    }

    function updateAttachUpLoad(rowIndex, columnIndex, value, item){

    	   if (AUIGrid.getCellValue(calGridID, rowIndex, "stus") != "Active" ){
    	         Common.alert("Only in ACT status can be reuploaded.");
    	  }
    	   else{
               $("#uploadBatchId").val(AUIGrid.getCellValue(calGridID, rowIndex, "batchId"));
               $("#uploadMemType").val(AUIGrid.getCellValue(calGridID, rowIndex, "batchMemType"));
    		   reuploadFile(rowIndex);
    	   }
    	}

    function reuploadFile(rowIndex){

        attchIndex = rowIndex;
        $("#uploadfile").click();

    }

    $(function() {

        $("#uploadfile").change(function(e){
            var formData = new FormData();
            formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
            formData.append("batchId", $("#uploadBatchId").val());
            formData.append("batchMemType", $("#uploadMemType").val());

            Common.ajaxFile("/attendance/csvUpload.do", formData, function (result) {
                Common.alert(result.message,fn_getCalSearchResultJsonList);
            });
        });
   });


</script>

<div id="popup_wrap_update" class="popup_wrap size_mid"><!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>Edit / Delete Attendance</h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE'/></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body"><!-- pop_body start -->
   <div style="display:none" >
            <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
               <input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
               <input type="text"  id="uploadBatchId" name="uploadBatchId"/>
               <input type="text"  id="uploadMemType" name="uploadMemType"/>
            </form>
   </div>
   <ul class="right_btns mb10">
     <li><p class="btn_blue"><span class="search"></span><a href="#" id="calSearchBtn"><spring:message code="sal.btn.search" /></a></p></li>
   </ul>
   <section class="search_table"><!-- search_table start -->
     <form id="calSearchEditDeleteForm" name="calSearchEditDeleteForm" method="get">
       <table class="type1"><!-- table start -->
         <caption>table</caption>
         <colgroup>
           <col style="width:150px" />
           <col style="width:*" />
         </colgroup>
         <tbody>
           <tr>
             <th scope="row"><spring:message code='cal.search.month'/></th>
             <td colspan='3'><input type="text" id="calMonthYear" name="calMonthYear" title="Month" class="j_date2" placeholder="Choose one" /></td>
           </tr>
           <tr id="rowMemType">
             <th scope="row"><spring:message code='cal.search.memType'/></th>
             <td colspan='3'>
               <select class="" id="calMemType" name="calMemType">
                 <option value="">Choose One</option>
                 <option value="4">Staff</option>
                 <option value="6677">Manager</option>
               </select>
             </td>
           </tr>
         </tbody>
       </table><!-- table end -->
     </form>
     <section class="search_result"><!-- search_result start -->
       <article class="grid_wrap"><!-- grid_wrap start -->
         <div id="cal_grid_wrap" class="autoGridHeight"></div>
       </article><!-- grid_wrap end -->
     </section><!-- search_result end -->
   </section><!-- search_table end -->
 </section>
</div><!-- popup_wrap end -->