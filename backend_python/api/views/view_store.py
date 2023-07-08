from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.models.store import Store
from api.serializers.store_serializer import StoreSerializer

# Create your views here.
@api_view(['GET'])
def getStores(request):
    stores = Store.objects.all()
    serializer = StoreSerializer(stores, many=True)

    return Response(serializer.data)