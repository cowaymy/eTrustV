<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
	<p>Information Message Area</p>
	</aside><!-- bottom_msg_box end -->

	</section><!-- container end -->
	<hr />

	</div><!-- wrap end -->

<script type="text/javascript">
    // 20190911 KR-MIN : for grid resizing
    $(document).ready(function(){
        resizeContents();
        gfn_resizeGridHeight();
    });

    $(window).resize(function () {
        // iframe contents area resize
         resizeContents();

         // grid resize
         gfn_resizeGridHeight();
     });

     // iframe contents area resize
     function resizeContents(){
         try {

             var iHeight = $(top).height();
             //alert($(top.document).contents().find("#mainTabTitle").length)
             if($(top.document).contents().find("#mainTabTitle") != null && $(top.document).contents().find("#mainTabTitle").length >0){
            	 iHeight = iHeight - ($(top.document).contents().find("#mainTabTitle").offset().top + $(top.document).contents().find("#mainTabTitle").height());
             }

             //alert(iHeight)
             //iHeight = iHeight - 100;  // remain message arae.

             if(Common.checkPlatformType() == "mobile") {
            	 $('.bottom_msg_box').css("display", "none");
             } else {
            	 iHeight = iHeight - 76;  // remain message arae.
             }

             $("#content").height(iHeight);
/*
             $.each($(document.body).find("article>div"), function(i){
            	 if( $($(document.body).find("article>div")[i]).hasClass("autoGridHeight") == false ){
            		 $($(document.body).find("article>div")[i]).addClass("autoGridHeight");
            	 }
             });
*/

/*
             if( $(document.body).find("article>div").length == 1 ){
            	 if( $($(document.body).find("article>div")[0]).hasClass("autoGridHeight") == false ){
                     $($(document.body).find("article>div")[0]).addClass("autoGridHeight");
                 }
             }else{
            	 $.each($(document.body).find("article>div"), function(i){
            		 var gridId = $(this).attr("id");
            		 AUIGrid.resize(GridCommon.makeGridId(gridId));
                 });
             }
 */
             $.each($(document.body).find("article>div"), function(i){
                 var gridId = $(this).attr("id");
                 AUIGrid.resize(GridCommon.makeGridId(gridId));
             });
         } catch (e) {}
     }

    // grid resize
    function gfn_resizeGridHeight(){
        // 20190917 KR-OHK : Apply array for grid resizing
        $.each($(".autoGridHeight"), function(){
            var gridId = $(this).attr("id");

            var gridHeight = $("#content").height() - $("#" + gridId).offset().top;
            var fizAreaHeight = $(".autoFixArea").height();

            if(fizAreaHeight == null){
                fizAreaHeight = 0;
            } else{
                fizAreaHeight = fizAreaHeight+10;
            }

            gridHeight = gridHeight - fizAreaHeight;

			if($(top.document).contents().find("#mainTabTitle") == null || $(top.document).contents().find("#mainTabTitle").length ==0){
				gridHeight = gridHeight + $(".bottom_msg_box").height() + 10;
			}

            var minHeight = 200;
            if(gridHeight < minHeight){
                 gridHeight = minHeight;
            }

            // 테스트
            gridHeight = gridHeight - 10;

             var myGridID = GridCommon.makeGridId(gridId);

             AUIGrid.resize(myGridID, null, gridHeight);
        });
     }
</script>