from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.models.category import Category
from api.serializers.category_serializer import CategorySerializer

@api_view(['GET'])
def getCategories(request):
    categories = Category.objects.all()
    serializer = CategorySerializer(categories, many=True)
    return Response(serializer.data)